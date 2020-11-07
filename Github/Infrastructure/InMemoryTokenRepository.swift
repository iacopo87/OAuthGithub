//
//  InMemoryTokenRepository.swift
//  Github
//
//  Created by Iacopo Pazzaglia on 07/11/2020.
//

import Foundation

class InMemoryTokenRepository: TokenRepository {
    private var tokenBag: TokenBag?
    
    func getToken() -> TokenBag? { tokenBag }
    
    func setToken(tokenBag: TokenBag?) throws { self.tokenBag = tokenBag }
    
    func resetToken() throws { tokenBag = nil }
}
