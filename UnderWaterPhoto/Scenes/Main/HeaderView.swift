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
	
	// MARK: - Internal Properties
	
	@ObservedObject var vm: MainViewModel
	@Binding var isLoadingContentFromGallery: Bool
	var userName: String
	var routeProcessScreen: (_ content: ContentModel, _ isProcessedVideo: Bool) -> Void
	
	// MARK: - Private Properties
	
	@State private var showImagePicker = false
	@State private var selectedImage: ContentModel?
	@State private var image: PhotosPickerItem?
	@State private var isCross = false
	@State private var isModalPresentedPicker =  false
	
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
						avatarImage: "divePixLogo",
						name: "",
						mail: ""
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
				if vm.state != .settings {
					
					addPhotoButtonView
						.frame(alignment: .bottom)
						.ignoresSafeArea()
//						.opacity(vm.state == .settings ? 0 : 1)
				}
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
			if vm.selectionState == .open {
				isModalPresentedPicker = true
			} else {
				if vm.isAnyContentSelected {
					vm.deleteSelectedContent()
				} else {
					vm.selectionState = .open
				}
			}
		}) {
			HStack {
				Image(
					systemName: vm.selectionState == .open 
					? "plus.circle.fill"
					: "minus.circle.fill"
				)
					.font(.system(size: 40))
					.padding([.leading], 20)
				Text(vm.headerActionButtonText)
					.font(.system(size: 17, weight: .semibold))
					.padding([.trailing], 20)
				Spacer()
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
			isPresented: $isModalPresentedPicker,
			selection: $image,
			matching: .any(of: [.images, .videos])
		)
		.onChange(of: image) { content in
			self.mapContentAndOpenProcessScreen(content: content)
		}
	}
	
	private func mapContentAndOpenProcessScreen(content: PhotosPickerItem?) {
		Task {
			if let contentType = content?.supportedContentTypes.first {
				self.isLoadingContentFromGallery = true
				if contentType.conforms(to: .movie) {
					if let video = try? await content?.loadTransferable(type: VideoTransferable.self) {
						let contentModel = ContentModel(
							id: UUID().uuidString,
							url: video.url.absoluteString
						)
						self.isLoadingContentFromGallery = false
						self.routeProcessScreen(contentModel, false)
					}
				} else if contentType.conforms(to: .image) {
					if let image = try? await content?.loadTransferable(type: Data.self) {
						let uiimage = UIImage(data: image)
						if let uiimage = uiimage {
							let contentModel = ContentModel(
								id: UUID().uuidString,
								image: uiimage
							)
							self.isLoadingContentFromGallery = false
							self.routeProcessScreen(contentModel, false)
						} else {
							print("image is nil")
						}
					}
				} else {
					print("Content doesnt conforms to image or movie")
				}
				image = nil
			}
		}
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
