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
		} content: {
			VStack {
				content
			}
		}
		.hideScrollIndicators()
		.height(min: 116.5, max: 116.5)
		.background(Color("back"))
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
	
	private lazy var backButton: UIButton = {
		let button = UIButton(type: .system)
		let image = UIImage(named: "back")
		button.setImage(image, for: .normal)
		button.tintColor = UIColor(named: "white")
		
		button.addTarget(self,
						 action: #selector(backButtonPressed),
						 for: .touchUpInside)
		return button
	}()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.text = L10n.SubscriptionVC.titleLabel
		label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
		label.textColor = UIColor(named: "white")
		return label
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addSwiftUIViewToViewController()
		
		navigationController?.interactivePopGestureRecognizer?.delegate = nil
		navigationItem.setHidesBackButton(true,
										  animated: true)
		let backButton = UIBarButtonItem(customView: backButton)
		navigationItem.leftBarButtonItem = backButton
		navigationItem.titleView = titleLabel
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = false
	}
	
	@objc
	func backButtonPressed() {
		navigationController?.popViewController(animated: true)
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
