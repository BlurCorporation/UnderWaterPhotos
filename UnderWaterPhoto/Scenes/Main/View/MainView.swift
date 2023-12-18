//
//  MainView.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 10.09.2023.
//

import SwiftUI
import UIKit
import ScalingHeaderScrollView


struct MainView: View {
    @ObservedObject var vm: MainViewModel
    @State private var progress: CGFloat = 0
    @State private var isLoading: Bool = false
    @State private var height: CGFloat = 0
    
    var languageSettingVC: () -> Void
    var routeProcessScreen: (_ image: UIImage?) -> Void
    var routeSubscriptionScreen: () -> Void
    
    var body: some View {
        VStack {
            ScalingHeaderScrollView {
                ZStack {
                    HeaderView(vm: vm,
                               progress: progress,
                               userName: vm.userName)
                    mainHeaderTextView
                        .padding([.leading, .trailing], 16)
                }
            } content: {
                switch vm.state {
                case .settings:
                    SettingsView(routeLanguageScreen: languageSettingVC,
                                 routeSubscriptionScreen: routeSubscriptionScreen)
                        .frame(height: 220)
                        .padding([.top], -32)
                case .main:
                    scrollContentView
                        .padding()
                case .clear:
                    emptyView
                        .padding()
                }
            }
            .hideScrollIndicators()
            .height(min: 188, max: vm.state == .settings ? 188 : 318)
            .allowsHeaderCollapse()
            .collapseProgress($progress)
            .pullToRefresh(isLoading: $isLoading,
                           color: Color.white) {
                switch vm.state {
                case .main, .clear:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        vm.fetch()
                        progress = 0
                        isLoading = false
                    }
                case .settings:
                    print(".setting")
                        isLoading = false
                }
                
            }
           .background(Color("blue"))
           .ignoresSafeArea()
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
               switch vm.state {
               case .main, .clear:
                   progress = 0
               case .settings:
                   progress = 1
               }
           }
        }
    }
    
    func changeProgress(progress: CGFloat) {
        self.progress = progress
    }
}

private extension MainView {
    var mainHeaderTextView: some View {
        Text("Cделай свои подводные фотографии лучше вместе с нами!")
            .foregroundColor(.white)
            .font(.system(size: 28, weight: .semibold))
            .opacity(3.0 - progress * 5)
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
                Text("Здесь будут загруженные тобой фото и видео")
                    .foregroundColor(Color("white"))
                    .font(.system(size: 20, weight: .medium))
                    .padding([.leading, .trailing], 36)
                    .multilineTextAlignment(.center)
            }
        }
        
    }
    
    
    var scrollContentView: some View {
        LazyVGrid(columns: [GridItem(), GridItem()]) {
            ForEach(vm.images) { image in
                Image(uiImage: image.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 24))
                    .shadow(radius: 5)
                    .onTapGesture {
                        routeProcessScreen(image.image)
                    }
            }
        }
    }
}

final class MainViewController: UIViewController {
    let viewModel: MainViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwiftUIViewToViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSwiftUIViewToViewController() {
        let goLanguageScreen = {
            let secondViewController = SceneBuildManager().buildLanguageScreen()
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        
        let routeProcessScreen = { image in
            let secondViewController = SceneBuildManager().buildProcessViewController(image: image)
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        
        let routeSubscriptionScreen = {
            let nextViewController = SceneBuildManager().buildSubscriptionView()
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
        let swiftUIViewController = UIHostingController(rootView: MainView(vm: viewModel,
                                                                           languageSettingVC: goLanguageScreen,
                                                                           routeProcessScreen: routeProcessScreen,
                                                                           routeSubscriptionScreen: routeSubscriptionScreen))
        self.addChild(swiftUIViewController)
        swiftUIViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(swiftUIViewController.view)
        swiftUIViewController.didMove(toParent: self)
        NSLayoutConstraint.activate([
            swiftUIViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            swiftUIViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            swiftUIViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            swiftUIViewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

#Preview {
    MainView( vm: MainViewModel(repository: Repository()), languageSettingVC: {}, routeProcessScreen: {image in }, routeSubscriptionScreen: {})
}


//#Preview {
//    MainView( languageSettingVC: {}, routeProcessScreen: {})
//}
