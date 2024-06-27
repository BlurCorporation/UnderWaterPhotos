//
//  SceneDelegate.swift
//  UnderWaterPhoyo
//
//  Created by Максим Косников on 03.09.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        setupRootViewController(windowScene: windowScene)
    }
}

// MARK: - Private methods
private extension SceneDelegate {
    func setupRootViewController(windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        let defaultsManager: DefaultsManagerable = DefaultsManager()
        let sceneBuildManager: Buildable = SceneBuildManager(userDefaultsManager: defaultsManager)
        let isUserAuth = {
            if let isUserAuth = defaultsManager.fetchObject(type: Bool.self, for: .isUserAuth) {
                return isUserAuth
            } else {
                return false
            }
        }()
        let viewController = {
            return isUserAuth ? sceneBuildManager.buildMainView() : sceneBuildManager.buildAuthViewController()
        }()
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        window.overrideUserInterfaceStyle = .light
        self.window = window
    }
}
