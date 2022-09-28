//
//  Errors.swift
//  WELLPLAY
//
//  Created by Nataliya Durdyeva on 9/27/22.
//

import Foundation
enum WellPlayError: LocalizedError {
    
    case invalidURL
    case thrownError(Error)
    case badResponse
    case noData
    case unableToDecode(Error?)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Unable to reach the server"
        case .thrownError(let error):
            return error.localizedDescription
        case .badResponse:
            return "The server sent back a bad response."
        case .noData:
            return "The server did not send back any data."
        case .unableToDecode(let error):
            if let error = error {
                return error.localizedDescription
            } else {
                return "Unable to decode :("
            }
        }
    }
}
