//
//  HttpClientTest.swift
//  GithubTests
//
//  Created by Iacopo Pazzaglia on 18/10/2020.
//

import XCTest
@testable import Github

private struct Title: Decodable, Equatable {
    var title: String
}

private class MockURLSessionDataTask: URLSessionDataTask {
    let callback: () -> Void
    init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    override func resume() {
        callback()
    }
}

private class MockURLSession: URLSession {
    var data: Data?
    var urlResponse: URLResponse?
    var error: Error?
    
    init(data: Data? = nil, urlResponse: URLResponse? = nil, error: Error? = nil) {
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
    }
    override func dataTask(with request: URLRequest,
                           completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let callback = { [weak self] in completionHandler(self?.data, self?.urlResponse, self?.error) }
        return MockURLSessionDataTask(callback: callback)
    }
    override func finishTasksAndInvalidate() { }
}

class HttpClientTest: XCTestCase {
    func test_performRequest_whenHttpErrr_returnHttpError() {
        let expect = expectation(description: "Wait promise fulfill")
        let client = HTTPClient(session: MockURLSession(data: Data(), urlResponse: MockURLSession.httpResponseKo, error: nil))
        
        var result: Result<String, HTTPClient.RequestError> = .success("fakeInit")
        client.performRequest(request: TestHelper.httpRequestGet) { (res: Result<String, HTTPClient.RequestError>) in
            result = res
            expect.fulfill()
        }

        wait(for: [expect], timeout: 0.5)
        XCTAssertEqual(result, .failure(.httpError))
    }
    
    func test_performRequest_whenRequesterror_returnRequestFailed() {
        let expect = expectation(description: "Wait promise fulfill")
        let error = NSError(domain: "aDomain", code: 0, userInfo: [:])
        let client = HTTPClient(session: MockURLSession(data: Data(), urlResponse: MockURLSession.httpResponseOk, error: error))
        
        var result: Result<String, HTTPClient.RequestError> = .success("fakeInit")
        client.performRequest(request: TestHelper.httpRequestGet) { (res: Result<String, HTTPClient.RequestError>) in
            result = res
            expect.fulfill()
        }

        wait(for: [expect], timeout: 0.5)
        XCTAssertEqual(result, .failure(.requestFailed))
    }
    
    func test_performRequest_whenEmptyData_returnEmptyDataError() {
        let expect = expectation(description: "Wait promise fulfill")
        let client = HTTPClient(session: MockURLSession(data: nil, urlResponse: MockURLSession.httpResponseOk))
        
        var result: Result<String, HTTPClient.RequestError> = .success("fakeInit")
        client.performRequest(request: TestHelper.httpRequestGet) { (res: Result<String, HTTPClient.RequestError>) in
            result = res
            expect.fulfill()
        }

        wait(for: [expect], timeout: 0.5)
        XCTAssertEqual(result, .failure(.responseDataEmpty))
    }
    
    func test_performRequest_whenDecodeFail_returnDecodeFailError() {
        let expect = expectation(description: "Wait promise fulfill")
        let expectedResponse = 42
        let intData = withUnsafeBytes(of: expectedResponse) { Data($0) }
        let client = HTTPClient(session: MockURLSession(data: intData, urlResponse: MockURLSession.httpResponseOk))
        
        var result: Result<String, HTTPClient.RequestError> = .success("fakeInit")
        client.performRequest(request: TestHelper.httpRequestGet) { (res: Result<String, HTTPClient.RequestError>) in
            result = res
            expect.fulfill()
        }

        wait(for: [expect], timeout: 0.5)
        XCTAssertEqual(result, .failure(.decodeFailed))
    }
    
    func test_performRequest_whenDecodeSuccess_returnDecodeData() {
        let expect = expectation(description: "Wait promise fulfill")
        let expectedResponse = "{\"title\": \"a title\"}".data(using: .utf8)
        let client = HTTPClient(session: MockURLSession(data: expectedResponse, urlResponse: MockURLSession.httpResponseOk))
        
        var result: Result<Title, HTTPClient.RequestError> = .success(Title(title: "default value"))
        client.performRequest(request: TestHelper.httpRequestGet) { (res: Result<Title, HTTPClient.RequestError>) in
            result = res
            expect.fulfill()
        }

        wait(for: [expect], timeout: 0.5)
        XCTAssertEqual(result, .success(Title(title: "a title")))
    }
}

// Private Methods
private extension MockURLSession {
    static var httpResponseOk: HTTPURLResponse? { HTTPURLResponse(url: URL(string: "http://test.com")!,
                                       statusCode: 200,
                                       httpVersion: "",
                                       headerFields: [:]) }
    static var httpResponseKo: HTTPURLResponse? {HTTPURLResponse(url: URL(string: "http://test.com")!,
                                       statusCode: 401,
                                       httpVersion: "",
                                       headerFields: [:]) }
}
