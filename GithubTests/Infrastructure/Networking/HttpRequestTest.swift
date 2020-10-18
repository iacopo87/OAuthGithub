//
//  HttpRequestTest.swift
//  GithubTests
//
//  Created by Iacopo Pazzaglia on 18/10/2020.
//

import XCTest
@testable import Github

class HttpRequestTest: XCTestCase {
    func test_asURLRequest_whenGet_set_httpMethod_properly() {
        let result = TestHelper.httpRequestGet.asURLRequest()
        
        XCTAssertEqual(result?.httpMethod, "GET")
    }
    
    func test_asURLRequest_whenGet_set_queryParams_properly() {
        let result = TestHelper.httpRequestGet.asURLRequest()
        
        XCTAssert(["http://test.com?aField=aFieldValue&otherField=42",
                   "http://test.com?otherField=42&aField=aFieldValue"].contains(result?.url?.absoluteString))
    }
    
    func test_asURLRequest_whenGet_set_httpBody_properly() {
        let result = TestHelper.httpRequestGet.asURLRequest()
        
        XCTAssertNil(result?.httpBody)
    }
    
    func test_asURLRequest_whenPost_set_httpMethod_properly() {
        let result = TestHelper.httpRequestPost.asURLRequest()
        
        XCTAssertEqual(result?.httpMethod, "POST")
    }
    
    func test_asURLRequest_whenPost_set_queryParams_properly() {
        let result = TestHelper.httpRequestPost.asURLRequest()
        
        XCTAssertEqual(result?.url?.absoluteString, "http://test.com")
    }
    
    func test_asURLRequest_whenPost_set_httpBody_properly() {
        let result = TestHelper.httpRequestPost.asURLRequest()
        
        XCTAssertEqual(result?.httpBody, try! JSONEncoder().encode(TestHelper.httpRequestPost.params))
    }
    
    func test_asURLRequest_set_headers_properly() {
        let result = TestHelper.httpRequestPost.asURLRequest()
        
        XCTAssertEqual(result!.allHTTPHeaderFields!.count, 2)
        XCTAssertEqual(result!.allHTTPHeaderFields!["Content-Type"], "application/json")
        XCTAssertEqual(result!.allHTTPHeaderFields!["someHeader"], "someHeaderValue")
    }
}

