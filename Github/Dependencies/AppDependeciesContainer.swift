//
//  AppDependeciesContainer.swift
//  Github
//
//  Created by Iacopo Pazzaglia on 17/10/2020.
//

import UIKit

class AppDependencyContainer {
    let deepLinkHandler = DeepLinkHandler()
    
    func makeMainViewController() -> UIViewController {
        let redirectUri = URL(string: "it.iacopo.github://authentication")!
        let oAuthService = OAuthService(oauthClient: LocalOauthClient())
        let deepLinkCallback: (DeepLink) -> Void = { deepLink in
            if case .oAuth(let url) = deepLink {
                oAuthService.exchangeCodeForToken(url: url)
            }
        }
        deepLinkHandler.addCallback(deepLinkCallback, forDeepLink: DeepLink(url: redirectUri)!)
        let loginVC = LoginViewController(oAuthService: oAuthService)
        let navigationController = UINavigationController(rootViewController: loginVC)
        return navigationController
    }
}
