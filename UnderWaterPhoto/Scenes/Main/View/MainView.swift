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
    
    var body: some View {
        VStack {
            ScalingHeaderScrollView {
                Color("blueDark")
                    .cornerRadius(40)
                    .padding([.bottom], 62)
                VStack {
                    Spacer()
                    ZStack {
                        addPhotoButtonView
                            .frame(alignment: .bottom)
                            .ignoresSafeArea()
                    }
                }
            } content: {
                scrollContentView
                    .padding()
                    
            }
            .hideScrollIndicators()
            .height(min: 188)
            .ignoresSafeArea()
        }
        .background(Color("blue"))
    }
    
    private var addPhotoButtonView: some View {
        LazyVStack {
            Button(action: {

            }, label: {
                Text("Редактировать Фото и Видео")
                    .foregroundColor(.white)
                    .frame(height: 80)
                    .frame(maxWidth: .infinity)
                    .background(Color("blue"))
                    .cornerRadius(24)
                    .padding([.leading, .trailing, .bottom], 16)
                    .shadow(color: .black, radius: 5)
            })
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
            .onAppear {
                vm.fetch()
            }
    }
}

final class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwiftUIViewToViewController()
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
