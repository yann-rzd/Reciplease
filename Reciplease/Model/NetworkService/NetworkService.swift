//
//  NetworkService.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 28/07/2022.
//

import Foundation
import Alamofire

final class NetworkService: NetworkServiceProtocol {

    init(_ network: NetworkServiceAlamofireProtocol = NetworkServiceAlamofire()) {
        self.network = network
    }
    
    // MARK: - INTERNAL : properties
    
    static let shared = NetworkService()
    
    // MARK: - INTERNAL : functions
    
    func fetch<T: Codable>(urlRequest: URLRequest, completionHandler: @escaping (Result<T, NetworkServiceError>)  -> Void) {
        network.fetch(urlRequest: urlRequest) { (result) in
            completionHandler(result)
        }
    }
    
    
//    func fetch<T: Codable>(url: URL, completionHandler: @escaping (Result<T, NetworkServiceError>)  -> Void) {
//        let urlRequest = URLRequest(url: url)
//        network.fetch(urlRequest: urlRequest) { (result) in
//            completionHandler(result)
//        }
//    }
    
    // MARK: - PRIVATE: properties
    
    private let network: NetworkServiceAlamofireProtocol
   
}
