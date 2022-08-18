//
//  NetworkServiceAlamofire.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 18/08/2022.
//

import Foundation
import Alamofire


protocol NetworkServiceAlamofireProtocol {
    func fetch<T: Codable>(urlRequest request: URLRequest, completionHandler: @escaping (Result<T, NetworkServiceError>) -> Void)
}

class NetworkServiceAlamofire: NetworkServiceAlamofireProtocol {

    func fetch<T: Codable>(urlRequest request: URLRequest, completionHandler: @escaping (Result<T, NetworkServiceError>) -> Void) {
        AF.request(request).validate().responseDecodable(of: T.self) { response in
            
            guard response.error == nil else {
                completionHandler(.failure(.failedToFetchUnknownError))
                return
            }
            
            guard let value = response.value else {
                completionHandler(.failure(.failedToFetchUnknownError))
                return
            }
            completionHandler(.success(value))
        }
    }
}
