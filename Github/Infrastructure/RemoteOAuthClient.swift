//
//  RemoteOAuthClient.swift
//  Github
//
//  Created by Iacopo Pazzaglia on 20/10/2020.
//

import Foundation

struct OAuthConfig {
    let authorizationUrl: URL
    let tokenUrl: URL
    let clientId: String
    let clientSecret: String
    let redirectUri: URL
    let scopes: [String]
}

class RemoteOAuthClient: OAuthClient {
    struct AuthParms: Encodable {
        let clientId: String
        let redirectUrl: String
        let state: String
        let scope: String
        
        private enum CodingKeys: String, CodingKey {
            case clientId = "client_id"
            case redirectUrl = "redirect_uri"
            case state
            case scope
        }
    }
    
    struct TokenParams: Encodable {
        let clientId: String
        let clientSecret: String
        let code: String
        let redirectUrl: String
        let state: String
        
        private enum CodingKeys: String, CodingKey {
            case clientId = "client_id"
            case clientSecret = "client_secret"
            case redirectUrl = "redirect_uri"
            case state
            case code
        }
    }
    
    struct TokenResponse: Decodable {
        let accessToken: String
        
        private enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
        }
    }
    
    private let config: OAuthConfig
    private let httpClient: HTTPClient
  
    init(config: OAuthConfig, httpClient: HTTPClient) {
        self.config = config
        self.httpClient = httpClient
    }
    
    func getAuthPageUrl(state: String) -> URL? {
        let params = AuthParms(clientId: config.clientId,
                               redirectUrl: config.redirectUri.absoluteString,
                               state: state,
                               scope: config.scopes.joined(separator: " "))
        let httpRequest = HttpRequest(baseUrl: config.authorizationUrl,
                                      method: .get,
                                      params: params,
                                      headers: [:])
        return httpRequest.asURLRequest()?.url
    }
    
    func exchangeCodeForToken(code: String, state: String, completion: @escaping (Result<TokenBag, Error>) -> Void) {
        let params = TokenParams(clientId: config.clientId,
                                 clientSecret: config.clientSecret,
                                 code: code,
                                 redirectUrl: config.redirectUri.absoluteString,
                                 state: state)
        let httpRequest = HttpRequest(baseUrl: config.tokenUrl,
                                      method: .get,
                                      params: params,
                                      headers: ["Accept": "application/json"])
        httpClient.performRequest(request: httpRequest) { (result: Result<TokenResponse, HTTPClient.RequestError>) in
            switch result {
            case .success(let response):
                completion(.success(TokenBag(accessToken: response.accessToken)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
