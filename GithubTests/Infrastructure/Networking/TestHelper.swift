//
//  TestHelper.swift
//  GithubTests
//
//  Created by Iacopo Pazzaglia on 18/10/2020.
//

import Foundation
@testable import Github

struct TestRequestParams: Encodable {
    let aField: String
    let otherField: Int
}

class TestHelper {
    static let httpRequestGet = HttpRequest(baseUrl: URL(string: "http://test.com")!,
                                            method: .get,
                                            params: TestRequestParams(aField: "aFieldValue", otherField: 42),
                                            headers: [:])
    
    static let httpRequestPost = HttpRequest(baseUrl: URL(string: "http://test.com")!,
                                             method: .post,
                                             params: TestRequestParams(aField: "aFieldValue", otherField: 42),
                                             headers:  ["someHeader": "someHeaderValue"])
}
