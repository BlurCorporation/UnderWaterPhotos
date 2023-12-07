//
//  ViewControllerSubscription.swift
//  UnderWaterPhoto
//
//  Created by Андрей Барсуков on 20.09.2023.
//

import SwiftUI
import UIKit
import ScalingHeaderScrollView

protocol SubscriptionViewControllerProtocol: UIViewController {
    
}

struct SubscriptionView: View {
    
    @StateObject private var viewModel = SubscriptionViewModel()
    
    var body: some View {
        ScalingHeaderScrollView {
            Color("blueDark")
                .cornerRadius(40, corners: [.bottomLeft, .bottomRight])
                .padding(.bottom, 16)
        } content: {
            VStack {
                content
            }
        }
        .hideScrollIndicators()
        .height(min: 166.5, max: 166.5)
        .background(Color("blue"))
        .ignoresSafeArea()
    }
    
    
    private var content: some View {
        Group {
            BenefitsView()
            ScrollPriceView()
                .padding(.top, 320)
            TextView()
            ButtonView()
                .frame(height: 50)
        }
    }
}


final class SubscriptionViewController: UIViewController {
    
    private var swiftUIViewController: UIHostingController<SubscriptionView>?

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

        self.swiftUIViewController = swiftUIViewController
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
    }
}
