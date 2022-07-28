//
//  NetworkService.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 28/07/2022.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    // MARK: - INTERNAL: properties
    
    static let shared = NetworkService()
    
    
    // MARK: - INTERNAL: methods
    
    func fetch<T: Decodable>(urlRequest: URLRequest, completionHandler: @escaping (Result<T, NetworkServiceError>) -> Void) {
        
        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil,
                  let data = data
            else {
                completionHandler(.failure(.failedToFetchUnknownError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  200...299 ~= response.statusCode
            else {
                completionHandler(.failure(.failedToFetchBadStatusCode))
                return
            }

            let jsonDecoder = JSONDecoder()
            
            do {
                let decodedData = try jsonDecoder.decode(T.self, from: data)
                completionHandler(.success(decodedData))
            } catch {
                print(error.localizedDescription)
                print(error)
                completionHandler(.failure(.failedToFetchCouldNoDecode))
            }
        }
        
        task.resume()
    }
    
    
    // MARK: - PRIVATE: proporties
    
    private let urlSession: URLSession
}
