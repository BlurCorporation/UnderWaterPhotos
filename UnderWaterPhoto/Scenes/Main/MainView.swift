//
//  MainView.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 10.09.2023.
//

import SwiftUI
import ScalingHeaderScrollView
import PhotosUI

struct MainView: View {
	@ObservedObject var vm: MainViewModel
	@State private var progress: CGFloat = 0
	@State private var isLoading = false
	@State private var height: CGFloat = 0
	@State private var isLoadingContentFromGallery = false
	
	@State var isToggle = true
	
	var languageSettingVC: () -> Void
	var routeProcessScreen: (_ content: ContentModel, _ isProcessedVideo: Bool) -> Void
	var routeSubscriptionScreen: () -> Void
	var logout: () -> Void
	
	var body: some View {
		ZStack {
			Color("blue")
			ScalingHeaderScrollView {
				ZStack {
					HeaderView(
						vm: vm,
						isLoadingContentFromGallery: $isLoadingContentFromGallery,
						userName: "DivePix",
						routeProcessScreen: routeProcessScreen
					)
					mainHeaderTextView
						.padding([.leading, .trailing], 16)
				}
			} content: {
				switch vm.state {
				case .settings:
					SettingsView(
						vm: SettingsViewModel(
							repository: vm.repository,
							defaultsManager: vm.userDefaultsManager,
							authService: vm.authService,
							routeToAuthScreen: logout
						),
						routeLanguageScreen: languageSettingVC,
						routeSubscriptionScreen: routeSubscriptionScreen
					)
					.frame(height: 44)
				case .main:
					scrollContentView
						.padding()
				case .clear:
					emptyView
						.padding()
				}
			}
			.modalIsPresented(vm.isModalPresented)
			.headerIsClipped(true)
			.hideScrollIndicators()
			.height(min: 188, max: vm.state == .settings ? 188 : 318)
			.allowsHeaderCollapse(vm.state != .settings)
			.collapseProgress($progress)
			.pullToRefresh(
				isLoading: $isLoading,
				color: Color.white
			) {
				switch vm.state {
				case .main, .clear:
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						vm.fetch()
						progress = 0
						isLoading = false
					}
				case .settings:
					isLoading = false
				}
			}
			.onChange(of: vm.state) { newValue in
				if newValue == .settings {
					progress = 1
				} else {
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.13) {
						progress = 0
					}
				}
			}
			.onAppear {
				vm.fetch()
			}
			if isLoadingContentFromGallery {
				ZStack {
					Color(.black)
						.opacity(0.3)
						.disabled(true)
					ProgressView()
						.progressViewStyle(.circular)
						.tint(.white)
						.scaleEffect(1.7)
				}
			}
		}
		.ignoresSafeArea(.container, edges: .all)
	}
	
	func changeProgress(progress: CGFloat) {
		self.progress = progress
	}
}

private extension MainView {
	var mainHeaderTextView: some View {
		Text(L10n.Extension.MainView.MainHeaderTextView.text)
			.foregroundColor(.white)
			.font(.system(size: 28, weight: .semibold))
			.opacity(vm.state == .settings ? 0 : 3.0 - progress * 5)
	}
	
	var emptyView: some View {
		Group {
			Spacer()
			Spacer()
			Spacer()
			VStack {
				Image(systemName: "photo")
					.font(.system(size: 32, weight: .medium))
					.foregroundColor(Color("white"))
				Text(L10n.Extension.MainView.EmptyView.text)
					.foregroundColor(Color("white"))
					.font(.system(size: 20, weight: .medium))
					.padding([.leading, .trailing], 36)
					.multilineTextAlignment(.center)
			}
		}
		
	}
	
	var scrollContentView: some View {
		LazyVGrid(columns: [GridItem(), GridItem()], spacing: 12) {
			ForEach($vm.images, id: \.id) { $item in
				ContentImage(contentData: $item)
				.onTapGesture {
					if vm.selectionState == .delete {
						item.selected.toggle()
					} else {
						let isVideoProcessed = item.url != nil
						self.routeProcessScreen(item, isVideoProcessed)
					}
				}
				.onLongPressGesture(minimumDuration: 0.2) {
					if vm.selectionState == .open {
						vm.selectionState = .delete
						print(vm.selectionState)
					}
				}
			}
		}
	}
}

struct ContentImage: View {
	@Binding var contentData: ContentModel
	
	var body: some View {
		ZStack {
			Image(uiImage: contentData.image ?? UIImage())
				.renderingMode(.original)
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(
					width: UIScreen.main.bounds.size.width / 2 - 24,
					height: 210, alignment: .center
				)
				.contentShape(.containerRelative)
				.clipped()
				.clipShape(.rect(cornerRadius: 24))
				.shadow(radius: 5)
			if contentData.selected {
				checkmark
			}
		}
	}
	
	var checkmark: some View {
		VStack {
			Spacer()
			HStack {
				Spacer()
				ZStack {
					Image(systemName: "checkmark.circle.fill")
						.foregroundStyle(.white, .blue)
					Image(systemName: "circle")
						.foregroundStyle(.white)
				}
				.frame(width: 20, height: 20)
				.padding(16)
			}
		}
	}
}

final class MainViewController: UIViewController {
	let viewModel: MainViewModel
	private let sceneBuildManager: Buildable
	private let defaultsManager: DefaultsManagerable
	private let repository: RepositoryProtocol
	private let authService: AuthServicable
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addSwiftUIViewToViewController()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = true
	}
	
	init(
		viewModel: MainViewModel,
		sceneBuildManager: Buildable,
		defaultsManager: DefaultsManagerable,
		repository: RepositoryProtocol,
		authService: AuthServicable
	) {
		self.viewModel = viewModel
		self.sceneBuildManager = sceneBuildManager
		self.defaultsManager = defaultsManager
		self.repository = repository
		self.authService = authService
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func addSwiftUIViewToViewController() {
		let goLanguageScreen = { [weak self] in
			guard let self = self else { return }
			let secondViewController = self.sceneBuildManager.buildLanguageScreen()
			self.navigationController?.pushViewController(secondViewController, animated: true)
		}
		
		let routeProcessScreen: (_ content: ContentModel, _ isProcessedVideo: Bool) -> Void = { [weak self] item, isProcessedVideo  in
			guard let self = self else { return }
			let secondViewController = self.sceneBuildManager.buildProcessViewController(
				defaultImage: item.defaultImage,
				image: item.image,
				alphaSetting: item.alphaSetting,
				url: item.url,
				processContenType: item.url == nil ? .image : .video,
				isProcessedVideo: isProcessedVideo
			)
			self.navigationController?.pushViewController(secondViewController, animated: true)
		}
		
		let routeSubscriptionScreen = { [weak self] in
			guard let self = self else { return }
			let nextViewController = self.sceneBuildManager.buildSubscriptionView()
			self.navigationController?.pushViewController(nextViewController, animated: true)
		}
		
		let logout = { [weak self] in
			guard let self = self else { return }
			authService.logout { error in
				print(error)
				return
			}
			let startViewController = self.sceneBuildManager.buildAuthViewController()
			let rootViewController = UINavigationController.init(rootViewController: startViewController)
			UIApplication.shared.windows.first?.rootViewController = rootViewController
		}
		
		let swiftUIViewController = UIHostingController(
			rootView: MainView(
				vm: self.viewModel,
				languageSettingVC: goLanguageScreen,
				routeProcessScreen: routeProcessScreen,
				routeSubscriptionScreen: routeSubscriptionScreen,
				logout: logout
			)
		)
		self.addChild(swiftUIViewController)
		swiftUIViewController.view.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(swiftUIViewController.view)
		swiftUIViewController.didMove(toParent: self)
		NSLayoutConstraint.activate([
			swiftUIViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
			swiftUIViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			swiftUIViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			swiftUIViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}
