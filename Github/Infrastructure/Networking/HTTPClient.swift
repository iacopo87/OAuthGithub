//
//  HTTPClient.swift
//  Github
//
//  Created by Iacopo Pazzaglia on 18/10/2020.
//

import Foundation

struct HTTPClient {
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum RequestError: Error {
        case requestMalformed
        case httpError
        case responseDataEmpty
        case requestFailed
        case decodeFailed
    }
    
    let session: URLSession
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func performRequest<RequestParams: Encodable, Response: Decodable>(request: HttpRequest<RequestParams>,
                                             completion: @escaping (_ result: Result<Response, RequestError>) -> Void) {
        guard let request = request.asURLRequest() else {
            completion(.failure(.requestMalformed))
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = self.getClientError(data: data, response: response, error: error) {
                completion(.failure(error))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response.self, from: data!)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodeFailed))
            }
            
        }.resume()
        session.finishTasksAndInvalidate()
    }
    
    private func getClientError(data: Data?, response: URLResponse?, error: Error?) -> RequestError? {
        if error != nil {
            return .requestFailed
        }
        
        if let httpUrlResponse = response as? HTTPURLResponse,
            !(200...299).contains(httpUrlResponse.statusCode) {
            return .httpError
        }
        
        if data == nil {
            return .responseDataEmpty
        }
        
        return nil
    }
}
