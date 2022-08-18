//
//  NetworkServiceError.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 28/07/2022.
//

import Foundation

enum NetworkServiceError: Error {
    case failedToFetchUnknownError
    case failedToFetchBadStatusCode
    case failedToFetchCouldNoDecode
    case badUrlRequest
}
