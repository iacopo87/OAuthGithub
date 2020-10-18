//
//  DeepLinkTest.swift
//  GithubTests
//
//  Created by Iacopo Pazzaglia on 18/10/2020.
//

import Foundation
import XCTest
@testable import Github

class DeepLinkTest: XCTestCase{
    func test_oAuthUrl_createDeepLink() {
        let url = URL(string: "it.iacopo.github://authentication?code=aCode")!
        
        let deepLink = DeepLink(url: url)
        
        XCTAssertNotNil(deepLink)
    }
    
    func test_unknownUrl_notCreateDeepLink() {
        let url = URL(string: "it.iacopo.github://notKnownPath")!
        
        let deepLink = DeepLink(url: url)
        
        XCTAssertNil(deepLink)
    }
    
    func test_deepLinkHandler_executeCallback_forOauthDeepLink_ifAdded() {
        var receivedDeeplink: DeepLink? = nil
        
        let expect = expectation(description: "Wait promise fulfill")
        let deepLink = DeepLink(url: URL(string: "it.iacopo.github://authentication")!)
        let deepLinkHandler = DeepLinkHandler()
        let callback: (DeepLink) -> Void = { deepLink in
            receivedDeeplink = deepLink
            expect.fulfill()
        }
        
        deepLinkHandler.addCallback(callback, forDeepLink: deepLink!)
        let actualDeepLink = DeepLink(url: URL(string: "it.iacopo.github://authentication?code=code&state=state")!)
        deepLinkHandler.handleDeepLinkIfPossible(deepLink: actualDeepLink!)
        
        wait(for: [expect], timeout: 0.5)
        XCTAssertEqual(actualDeepLink, receivedDeeplink)
    }
}

