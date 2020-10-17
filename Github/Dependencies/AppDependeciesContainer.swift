//
//  AppDependeciesContainer.swift
//  Github
//
//  Created by Iacopo Pazzaglia on 17/10/2020.
//

import UIKit

class AppDependencyContainer {
    func makeMainViewController() -> UIViewController {
        let oAuthService = OAuthService(oauthClient: LocalOauthClient())
        let loginVC = LoginViewController(oAuthService: oAuthService)
        let navigationController = UINavigationController(rootViewController: loginVC)
        return navigationController
    }
}
