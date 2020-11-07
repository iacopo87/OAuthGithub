//
//  TokenRepository.swift
//  Github
//
//  Created by Iacopo Pazzaglia on 07/11/2020.
//

import Foundation

protocol TokenRepository {
    func getToken() -> TokenBag?
    func setToken(tokenBag: TokenBag?) throws
    func resetToken() throws
}
