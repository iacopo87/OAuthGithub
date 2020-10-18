//
//  SceneDelegate.swift
//  Github
//
//  Created by Iacopo Pazzaglia on 17/10/2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let dependencyContainer = AppDependencyContainer()
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let mainVC = dependencyContainer.makeMainViewController()
        self.window = window
        window.frame = UIScreen.main.bounds
        window.rootViewController = mainVC
        window.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let urlContext = URLContexts.first {
            let url = urlContext.url
            if let deepLink = DeepLink(url: url) {
                dependencyContainer.deepLinkHandler.handleDeepLinkIfPossible(deepLink: deepLink)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

