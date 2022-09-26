//
//  NetworkServiceAlamofireProtocol.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 21/09/2022.
//

import Foundation

protocol NetworkServiceAlamofireProtocol {
    func fetch<T: Codable>(urlRequest request: URLRequest, completionHandler: @escaping (Result<T, NetworkServiceError>) -> Void)
}
