//
//  NetworkServiceFailureMock.swift
//  RecipleaseTests
//
//  Created by Yann Rouzaud on 19/09/2022.
//

import Foundation
@testable import Reciplease

final class NetworkServiceFailureMock: NetworkServiceProtocol {
    func fetch<T>(urlRequest: URLRequest, completionHandler: @escaping (Result<T, NetworkServiceError>) -> Void) where T : Decodable, T : Encodable {
        completionHandler(.failure(.badUrlRequest))
    }
    
    func fetch<T>(url: URL, completionHandler: @escaping (Result<T, NetworkServiceError>) -> Void) where T : Decodable, T : Encodable {
        completionHandler(.failure(.badUrlRequest))
    }
    
    
}
