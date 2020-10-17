//
//  LocalOauthClient.swift
//  Github
//
//  Created by Iacopo Pazzaglia on 17/10/2020.
//

import Foundation


class LocalOauthClient: OAuthClient {
    func getAuthPageUrl(state: String) -> URL? {
        let urlString = "https://github.com/login/oauth/authorize?client_id=yourClientId&redirect_uri=it.iacopo.github://authentication&s&scopes=repo,user&state=\(state)"
        
        return URL(string: urlString)!
    }
}
