//
//  OAuthService.swift
//  Github
//
//  Created by Iacopo Pazzaglia on 17/10/2020.
//

import Foundation

protocol OAuthClient {
    func getAuthPageUrl(state: String) -> URL?
}

class OAuthService {
    private let oauthClient: OAuthClient
    private var state: String?

    init(oauthClient: OAuthClient) {
        self.oauthClient = oauthClient
    }
    
    func getAuthPageUrl() -> URL? {
        state = UUID().uuidString
        return oauthClient.getAuthPageUrl(state: state!)
    }
}
