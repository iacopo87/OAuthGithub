//
//  OAuthServiceTest.swift
//  GithubTests
//
//  Created by Iacopo Pazzaglia on 18/10/2020.
//

import Foundation
import XCTest
@testable import Github

class MockOAuthClient: OAuthClient {
    var authPageCalls = [String]()
    var exchangeCodeCall = [(String, String)]()
    
    func getAuthPageUrl(state: String) -> URL? {
        authPageCalls.append(state)
        return nil
    }
    func exchangeCodeForToken(code: String,
                              state: String,
                              completion: @escaping (Result<TokenBag, Error>) -> Void) {
        exchangeCodeCall.append((code, state))
    }

}

class OAuthServiceTest: XCTestCase{
    func test_getAuthPageUrl_callOathClient_getAuthPageUrl() {
        let oAuthClient = MockOAuthClient()
        let oAuthService = OAuthService(oauthClient: oAuthClient)
        
        _ = oAuthService.getAuthPageUrl(state: "aState")
        
        XCTAssertEqual(oAuthClient.authPageCalls.count, 1)
        XCTAssertEqual(oAuthClient.authPageCalls.first, "aState")
    }
    
    func test_exchangeCodeForToken_whenTheLinkIsCorrect_calls_oauthClient_exchangeCodeForToken() {
        let url = URL(string: "it.iacopo.github://?code=aCode&state=aState")!
        let oAuthClient = MockOAuthClient()
        let oAuthService = OAuthService(oauthClient: oAuthClient)
        
        _ = oAuthService.getAuthPageUrl(state: "aState")
        oAuthService.exchangeCodeForToken(url: url)
        
        XCTAssertEqual(oAuthClient.exchangeCodeCall.count, 1)
        XCTAssertEqual(oAuthClient.exchangeCodeCall.first?.0, "aCode")
        XCTAssertEqual(oAuthClient.exchangeCodeCall.first?.1, "aState")
    }
    
    func test_exchangeCodeForToken_whenTheLinkIsCorrect_andStateIsWrong_doesntCalls_oauthClient_exchangeCodeForToken() {
        let url = URL(string: "it.iacopo.github://?code=aCode&state=aState")!
        let oAuthClient = MockOAuthClient()
        let oAuthService = OAuthService(oauthClient: oAuthClient)
        
        _ = oAuthService.getAuthPageUrl(state: "anotherState")
        oAuthService.exchangeCodeForToken(url: url)
        
        XCTAssertEqual(oAuthClient.exchangeCodeCall.count, 0)
    }
    
    func test_exchangeCodeForToken_whenTheLinkDoesntContainCode_doesntCalls_oauthClient_exchangeCodeForToken() {
        let url = URL(string: "it.iacopo.github://?state=aState")!
        let oAuthClient = MockOAuthClient()
        let oAuthService = OAuthService(oauthClient: oAuthClient)
        
        _ = oAuthService.getAuthPageUrl(state: "aState")
        oAuthService.exchangeCodeForToken(url: url)
        
        XCTAssertEqual(oAuthClient.exchangeCodeCall.count, 0)
    }
    
    func test_exchangeCodeForToken_whenTheLinkDoesntContainState_doesntCalls_oauthClient_exchangeCodeForToken() {
        let url = URL(string: "it.iacopo.github://?code=aCode")!
        let oAuthClient = MockOAuthClient()
        let oAuthService = OAuthService(oauthClient: oAuthClient)
        
        _ = oAuthService.getAuthPageUrl(state: "aState")
        oAuthService.exchangeCodeForToken(url: url)
        
        XCTAssertEqual(oAuthClient.exchangeCodeCall.count, 0)
    }
}
