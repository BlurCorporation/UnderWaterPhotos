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
    var body: some View {
        VStack {
            ScalingHeaderScrollView {
                Color(UIColor(.blue))
                    .cornerRadius(40)
                    .padding([.bottom], 20)
                VStack {
                    Spacer()
                    ZStack {
                        
                        
                        addPhoto
                            .frame(alignment: .bottom)
//                            .padding([.bottom], -20)
                            .ignoresSafeArea()
                        
                    }
                }
            } content: {
                scrollContent
                    .padding()
            }
            .hideScrollIndicators()
            .height(min: 188)
            .ignoresSafeArea()
        }
    }
    
    private var addPhoto: some View {
        LazyVStack {
            Button(action: {

            }, label: {
                Text("Редактировать Фото и Видео")
                    .foregroundColor(.white)
                    .frame(height: 80)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .cornerRadius(24)
                    .padding([.leading, .trailing], 16)
            })
        }
    }
    
    private var scrollContent: some View {
        LazyVStack {
            ForEach(0..<100) { _ in
                HStack {
                    Image("emptyImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Image("emptyImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
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
