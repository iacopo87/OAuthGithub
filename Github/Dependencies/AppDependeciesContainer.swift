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
        let oAuthConfig = OAuthConfig(authorizationUrl: URL(string: "https://github.com/login/oauth/authorize")!,
                                      tokenUrl: URL(string: "https://github.com/login/oauth/access_token")!,
                                      clientId: "yourClientId",
                                      clientSecret: "yourClientSecret",
                                      redirectUri: redirectUri,
                                      scopes: ["repo", "user"])
        let oAuthClient = RemoteOAuthClient(config: oAuthConfig, httpClient: HTTPClient())
        let oAuthService = OAuthService(oauthClient: oAuthClient)
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
