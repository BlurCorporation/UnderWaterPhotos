//
//  HeaderView.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 26.10.2023.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct HeaderView: View {
	@State private var showImagePicker: Bool = false
	@State private var selectedImage: ContentModel?
	@ObservedObject var vm: MainViewModel
	@State private var image: PhotosPickerItem?
//	var progress: CGFloat
	var userName: String
	var routeProcessScreen: (_ content: ContentModel) -> Void
	@State private var isCross: Bool = false
	
	var headerBottomPadding: CGFloat {
		switch vm.state {
		case .main:
			return 62
		case .settings:
			return 82
		case .clear:
			return 62
		}
	}
	
	var body: some View {
		Color("blueDark")
			.cornerRadius(40, corners: [.bottomLeft, .bottomRight])
			.padding([.bottom], headerBottomPadding)
		VStack {
			HStack {
				switch vm.state {
				case .settings:
					SettingsNavBarView(
						avatarImage: vm.avatarImage,
						name: vm.userName,
						mail: vm.mail
					)
				default:
					navBar
				}
				Spacer()
				CrossButtonView(isCross: isCross)
					.onTapGesture {
						withAnimation {
							isCross.toggle()
							if isCross {
								vm.state = .settings
								vm.ttoggle()
							} else {
								if vm.isEmpty() {
									vm.state = .clear
								} else {
									vm.state = .main
								}
							}
						}
					}
			}
			.padding([.top], 49)
			.padding([.leading, .trailing], 16)
			Spacer()
			ZStack {
				addPhotoButtonView
					.frame(alignment: .bottom)
					.ignoresSafeArea()
					.opacity(vm.state == .settings ? 0 : 1)
			}
			.onAppear {
				switch vm.state {
				case .main, .clear:
					isCross = false
				case .settings:
					isCross = true
				}
			}
		}
		.onChange(of: selectedImage) { item in
			guard let item = item else { return }
			routeProcessScreen(item)
		}
	}
}

private extension HeaderView {
	var navBar: some View {
		HStack {
			Text(L10n.Extension.HeaderView.NavBar.text(userName))
				.foregroundColor(.white)
				.font(.system(size: 20, weight: .medium))
		}
	}
	
	var addPhotoButtonView: some View {
		Button(action: {
			vm.isModalPresented = true
		}) {
			HStack(spacing: 16) {
				Image(systemName: "plus.circle.fill")
					.font(.system(size: 40))
					.padding([.leading], 20)
				Text(L10n.Extension.HeaderView.AddPhotoButtonView.text)
					.font(.system(size: 17, weight: .semibold))
					.padding([.trailing], 20)
			}
			.foregroundColor(Color("white"))
			.frame(height: 80)
			.frame(maxWidth: .infinity)
			.background(Color("blue"))
			.cornerRadius(24)
			.padding([.leading, .trailing, .bottom], 16)
			.shadow(color: .black, radius: 5)
		}
		.photosPicker(
			isPresented: $vm.isModalPresented,
			selection: $image,
			matching: .any(of: [.images, .videos])
		)
		.presentationDetents([.fraction(0.99)])
		.onChange(of: image) { content in
			Task {
				if let contentType = content?.supportedContentTypes.first {
					if contentType.conforms(to: .movie) {
						if let video = try? await content?.loadTransferable(type: VideoTransferable.self) {
							let contentModel = ContentModel(
								id: UUID().uuidString,
								image: UIImage(),
								url: video.url.absoluteString
							)
							self.routeProcessScreen(contentModel)
						}
					} else if contentType.conforms(to: .image) {
						if let image = try? await content?.loadTransferable(type: Image.self) {
							let uiimage = ImageRenderer(content: image).uiImage
							if let uiimage = uiimage {
								let contentModel = ContentModel(
									id: UUID().uuidString,
									image: uiimage
								)
								self.routeProcessScreen(contentModel)
							} else {
								print("image is nil")
							}
						}
					} else {
						print("Content doesnt conforms to image or movie")
					}
				}
			}
		}
//		.simultaneousGesture(TapGesture()
//		   .onEnded({
//			   vm.isModalPresented = true
//		   })
//		)
	}
}

struct CrossButtonView: View {
	var isCross: Bool
	var body: some View {
		ZStack {
			Rectangle()
				.frame(width: 40, height: 40)
				.foregroundColor(Color("blueDark"))
			VStack {
				Rectangle()
					.frame(width: 24, height: 4)
					.foregroundColor(Color("white"))
					.cornerRadius(3)
					.rotationEffect(.degrees(isCross ? 45 : 0), anchor: .center)
					.offset(x: isCross ? 0 : -8, y: isCross ? 6 : 0)
				Rectangle()
					.frame(width: 24, height: 4)
					.foregroundColor(Color("white"))
					.cornerRadius(3)
					.rotationEffect(.degrees(isCross ? -45 : 0), anchor: .center)
					.offset(x: isCross ? 0 : 8, y: isCross ? -6 : 0)
			}
		}
	}
}

struct VideoTransferable: Transferable {
	let url: URL
	
	static var transferRepresentation: some TransferRepresentation {
		FileRepresentation(contentType: .movie) { exporting in
			return SentTransferredFile(exporting.url)
		} importing: { received in
			let origin = received.file
			let filename = origin.lastPathComponent
			let copied = URL.documentsDirectory.appendingPathComponent(filename)
			let filePath = copied.path()
			
			if FileManager.default.fileExists(atPath: filePath) {
				try FileManager.default.removeItem(atPath: filePath)
			}
			
			try FileManager.default.copyItem(at: origin, to: copied)
			return VideoTransferable(url: copied)
		}
	}
}
