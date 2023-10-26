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
    
    var body: some View {
        VStack {
            ScalingHeaderScrollView {
                ZStack {
                    HeaderView(progress: progress,
                               userName: vm.userName)
                    Spacer()
                    mainHeaderTextView
                        .padding([.leading, .trailing], 16)
                }
            } content: {
                if vm.images.isEmpty {
                    emptyView
                        .padding()
                } else {
                    scrollContentView
                        .padding()
                }
            }
            .hideScrollIndicators()
            .height(min: 188, max: 318)
            .collapseProgress($progress)
            .allowsHeaderCollapse()
            .ignoresSafeArea()
            .onAppear {
                vm.fetch()
            }
        }
        .background(Color("blue"))
    }
    
    private var mainHeaderTextView: some View {
        Text("Cделай свои подводные фотографии лучше вместе с нами!")
            .foregroundColor(.white)
            .font(.system(size: 28, weight: .semibold))
            .opacity(1.0 - progress * 5)
    }
    
    private var emptyView: some View {
        Group {
            Spacer()
            Spacer()
            Spacer()
            Image(systemName: "photo")
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(Color("grey"))
            Text("Здесь буду загруженные тобой фото и видео")
                .foregroundColor(Color("grey"))
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
