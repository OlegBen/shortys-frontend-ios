//
//  ShorterLinkResponse.swift
//  Shortys
//
//  Created by user on 22.12.2021.
//

import Foundation

// MARK: ShorterLinkResponse
struct ShorterLinkResponse: Codable {
    let id: Int?
    let originalLink: String?
    let shortenedLink: String?
    let shortenerLinkEnd: String?
    let clicked: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case originalLink = "original_link"
        case shortenedLink = "shortened_link"
        case shortenerLinkEnd = "shortener_link_end"
        case clicked
    }
}

