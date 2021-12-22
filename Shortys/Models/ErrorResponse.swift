//
//  ErrorResponse.swift
//  Shortys
//
//  Created by user on 22.12.2021.
//

import Foundation

// MARK: ErrorResponse
struct ErrorResponse: Codable {
    let error: String
    let errorDescription: String
    
    enum CodingKeys: String, CodingKey {
        case error
        case errorDescription
    }
}
