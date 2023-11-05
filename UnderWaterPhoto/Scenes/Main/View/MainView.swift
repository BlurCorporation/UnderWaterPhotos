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
    @StateObject private var vm = MainViewModel()
    @State var progress: CGFloat = 0
    @State private var isLoading: Bool = false
    @State var height: CGFloat = 0
    
    var body: some View {
        VStack {
            ScalingHeaderScrollView {
                ZStack {
                    HeaderView(vm: vm,
                               progress: progress,
                               userName: vm.userName)
                    Spacer()
                    mainHeaderTextView
                        .padding([.leading, .trailing], 16)
                }
            } content: {
                switch vm.state {
                case .settings:
                    SettingsView()
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
                        withAnimation(.easeIn(duration: 0.2)) {
                            vm.fetch()
                            isLoading = false
                            progress = 0
                        }
                    }
                case .settings:
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
    
    private var mainHeaderTextView: some View {
        Text("Cделай свои подводные фотографии лучше вместе с нами!")
            .foregroundColor(.white)
            .font(.system(size: 28, weight: .semibold))
            .opacity(3.0 - progress * 5)
    }
    
    private var emptyView: some View {
        Group {
            Spacer()
            Spacer()
            Spacer()
            Image(systemName: "photo")
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(Color("white"))
            Text("Здесь будут загруженные тобой фото и видео")
                .foregroundColor(Color("white"))
                .font(.system(size: 20, weight: .medium))
                .padding([.leading, .trailing], 36)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
    
    
    private var scrollContentView: some View {
        LazyVGrid(columns: [GridItem(), GridItem()]) {
            ForEach(vm.images) { image in
                Image(image.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}

final class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwiftUIViewToViewController()
        navigationController?.isNavigationBarHidden = true
    }
    
    func addSwiftUIViewToViewController() {
        let swiftUIViewController = UIHostingController(rootView: MainView())
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
