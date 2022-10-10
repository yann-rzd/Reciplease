//
//  NetworkServiceProtocol.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 28/07/2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetch<T: Codable>(urlRequest: URLRequest, completionHandler: @escaping (Result<T, NetworkServiceError>) -> Void)
}
