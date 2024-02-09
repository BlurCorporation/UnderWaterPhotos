//
//  LanguageSettingView.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 07.11.2023.
//

import SwiftUI
import ScalingHeaderScrollView

struct LanguageSettingView: View {
    @StateObject private var vm = LanguageSettingViewModel()
    
    var body: some View {
        ScalingHeaderScrollView {
            Color(L10n.LanguageSettingView.Body.color)
                .cornerRadius(40, corners: [.bottomLeft, .bottomRight])
        } content: {
            List(vm.languages, id: \.self) { language in
                SettingRowView(setting: language.title,
                               additionalText: L10n.LanguageSettingView.Body.Content.additionalText,
                                   symbol: changeSymbol(language: language))
                    .onTapGesture {
                        vm.changeLanguage(language: language)
                    }
                    .listRowBackground(Color(L10n.LanguageSettingView.Body.OnTapGesture.ListRowBackground.color))
                .frame(maxWidth: .infinity)
            }
            .environment(\.defaultMinListRowHeight, 44)
            .frame(height: 220)
            .listStyle(.plain)
                .frame(height: 220)
                .padding([.top], 39)
        }
        .hideScrollIndicators()
        .height(min: 116.5, max: 116.5)
        .background(Color(L10n.LanguageSettingView.Body.Content.Background.color))
       .ignoresSafeArea()
    }
    
    func changeSymbol(language: Languages) -> String{
        if vm.selectedLanguage == language {
            return L10n.LanguageSettingView.ChangeSymbol.if
        } else {
            return L10n.LanguageSettingView.ChangeSymbol.else
        }
    }
}

class LanguageSettingViewController: UIViewController {
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: L10n.LanguageSettingViewController.BackButton.Image.name)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: L10n.LanguageSettingViewController.BackButton.Button.TintColor.name)
        
        button.addTarget(self,
                         action: #selector(backButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.LanguageSettingViewController.titleLabel
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(named: L10n.LanguageSettingViewController.TitleLabel.colorName)
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
        
        let swiftUIViewController = UIHostingController(rootView: LanguageSettingView())
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


//#Preview {
//    LanguageSettingView()
//}
