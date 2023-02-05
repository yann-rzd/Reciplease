//
//  NetworkServiceTests.swift
//  RecipleaseTests
//
//  Created by Yann Rouzaud on 11/08/2022.
//

import XCTest
@testable import Reciplease

class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService!
    
    override func setUp() {
        super.setUp()
        self.networkService = NetworkService(NetworkServiceAlamofireMock())
    }
    
    
    
    func testGivenUrlRequest_whenFetch_thenError() {
        let url = URL(string: "www.google.com")!
        let urlRequest = URLRequest(url: url)
        networkService.fetch(urlRequest: urlRequest) { (result: Result<RecipesResponse, NetworkServiceError>) in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .badUrlRequest)
            case .success:
                XCTFail()
                return
            }
        }
    }
}
