//
//  OAuthService.swift
//  Github
//
//  Created by Iacopo Pazzaglia on 17/10/2020.
//

import Foundation

protocol OAuthClient {
    func getAuthPageUrl(state: String) -> URL?
    func exchangeCodeForToken(code: String,
                              state: String,
                              completion: @escaping (Result<TokenBag, Error>) -> Void)
}

struct TokenBag {
    let accessToken: String
}

class OAuthService {
    enum OAthError: Error {
        case malformedLink
        case exchangeFailed
    }
    private let oauthClient: OAuthClient
    private let tokenRepository: TokenRepository
    private var state: String?
    var onAuthenticationResult: ((Result<TokenBag, Error>) -> Void)?

    init(oauthClient: OAuthClient, tokenRepository: TokenRepository) {
        self.oauthClient = oauthClient
        self.tokenRepository = tokenRepository
    }
    
    func getAuthPageUrl(state: String = UUID().uuidString) -> URL? {
        self.state = state
        return oauthClient.getAuthPageUrl(state: state)
    }
    
    
    func exchangeCodeForToken(url: URL) {
        guard let state = state, let code = getCodeFromUrl(url: url) else {
            onAuthenticationResult?(.failure(OAthError.malformedLink))
            return
        }
        
        oauthClient.exchangeCodeForToken(code: code, state: state) { [weak self] result in
            switch result {
            case .success(let tokenBag):
                try? self?.tokenRepository.setToken(tokenBag: tokenBag)
                self?.onAuthenticationResult?(.success(tokenBag))
            case .failure:
                self?.onAuthenticationResult?(.failure(OAthError.exchangeFailed))
            }
        }
    }
}

//MARK: - Private Methods
private extension OAuthService {
    func getCodeFromUrl(url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let code = components?.queryItems?.first(where: { $0.name == "code" })?.value
        let state = components?.queryItems?.first(where: { $0.name == "state" })?.value
        
        if let code = code, let state = state, state == self.state {
            return code
        } else {
            return nil
        }
    }
}
