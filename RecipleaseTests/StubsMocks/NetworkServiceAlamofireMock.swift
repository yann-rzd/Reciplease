//
//  NetworkServiceAlamofireMock.swift
//  RecipleaseTests
//
//  Created by Yann Rouzaud on 19/09/2022.
//

import Foundation
@testable import Reciplease

final class NetworkServiceAlamofireMock: NetworkServiceAlamofireProtocol {
    func fetch<T>(urlRequest request: URLRequest, completionHandler: @escaping (Result<T, NetworkServiceError>) -> Void) where T : Decodable, T : Encodable {
        completionHandler(.failure(.badUrlRequest))
    }
}
