//
//  ViewControllerSubscription.swift
//  UnderWaterPhoto
//
//  Created by Андрей Барсуков on 20.09.2023.
//

import SwiftUI
import UIKit

protocol SubscriptionViewControllerProtocol: UIViewController {
    
}

struct SubscriptionView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    Button(action: {
                        // action
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding()
                    }

                    Spacer()

                    Text("Подписка")
                        .padding(.trailing, 50)
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 108)
                }
                .background(Color.blue)
                .cornerRadius(30)
                .ignoresSafeArea()


                Image("benefits")
                    .padding(.top, 16)
                    .aspectRatio(contentMode: .fit)


                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(1..<4) { index in
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: 200, height: 200)
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                Text("Oформляя подписку вы соглашаетесь на  и  ")
                    .foregroundColor(.white)
                    .font(.title3)
                
                Spacer()
                
                Button(action: {
                    // action
                }) {
                    Text("Оформить")
                        .frame(maxWidth: 344, maxHeight: 55)
                        .foregroundColor(.brown)
                        .background(Color.white)
                        .padding(.bottom, 1)
                        .cornerRadius(16)
                }

            }
            .navigationBarHidden(true) // Скрыть стандартную навигационную строку
            .background(Color.brown)
        }
    }
}






final class SubscriptionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwiftUIViewToViewController()
    }
    
    func addSwiftUIViewToViewController() {
            let swiftUIViewController = UIHostingController(rootView: SubscriptionView())
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

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
    }
}


