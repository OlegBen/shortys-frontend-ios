//
//  ShorterLinksListResponse.swift
//  Shortys
//
//  Created by user on 23.12.2021.
//

import Foundation

// MARK: ShorterLinksListResponse
struct ShorterLinksListResponse: Codable {
    let count: Int?
    let results: [ShorterLinkResponse]?
    
    enum CodingKeys: String, CodingKey {
        case count
        case results
    }
}
