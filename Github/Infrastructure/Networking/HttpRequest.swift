//
//  HttpRequest.swift
//  Github
//
//  Created by Iacopo Pazzaglia on 18/10/2020.
//

import Foundation

struct HttpNoParamRequest: Encodable {}

struct HttpRequest<Params: Encodable> {
    var baseUrl: URL
    var method: HTTPClient.Method
    var params: Params
    var headers: [String: String]
}

extension HttpRequest {
    func asURLRequest() -> URLRequest? {
        guard let url = url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        setCommonHeaders(in: &request)
        request.httpBody = body
        
        return request
    }
}

private extension HttpRequest {
    var url: URL? {
        if method == .get {
            var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
            components?.queryItems = queryItems
            return components?.url
        } else {
            return baseUrl
        }
    }
    
    var body: Data? {
        guard method != .get, let httpBody = try? JSONEncoder().encode(params) else { return nil }
        return httpBody
    }
    
    var queryItems: [URLQueryItem]? {
        try? params.asDictionary().map { URLQueryItem(name: $0, value: "\($1)") }
    }
    
    func setCommonHeaders(in request: inout URLRequest) {
        for (key, value) in commonHeaders {
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
    
    var commonHeaders: [String: String] {
        ["Content-Type": "application/json"]
    }
}
