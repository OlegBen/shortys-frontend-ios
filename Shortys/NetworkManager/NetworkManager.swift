//
//  NetworkManager.swift
//  Shortys
//
//  Created by user on 22.12.2021.
//

import Foundation
import Alamofire

// MARK: NetworkManagerProtocol
protocol NetworkManagerProtocol {
    /// Метод создания короткой ссылки
    /// - Parameter link: Ссылка для сокращения
    /// - Parameter linkEnd: Окончание ссылки
    /// - Parameter completionHandler: (ShorterLinkResponse?, ErrorResponse?) -> Void
    func create(link: String, linkEnd: String, completionHandler: @escaping (ShorterLinkResponse?, ErrorResponse?) -> Void)
    
    /// Получить список ссылок
    /// - Parameter completionHandler: (ShorterLinksListResponse?, ErrorResponse?) -> Void
    func getShorterLinks(completionHandler: @escaping (ShorterLinksListResponse?, ErrorResponse?) -> Void)
}

// MARK: NetworkManager
class NetworkManager: NetworkManagerProtocol {
    /// Сетевой слой
    let networkLayer = NetworkLayer(session: Session())
    
    /// Метод создания короткой ссылки
    /// - Parameter link: Ссылка для сокращения
    /// - Parameter linkEnd: Окончание ссылки
    /// - Parameter completionHandler: (ShorterLinkResponse?, ErrorResponse?) -> Void
    func create(link: String, linkEnd: String, completionHandler: @escaping (ShorterLinkResponse?, ErrorResponse?) -> Void) {
        let params = [
            "original_link": link,
            "shortener_link_end": linkEnd
        ]
        self.networkLayer.requestData(ShorterLinkResponse.self,
                                      authType: .auth,
                                      endpoint: .create,
                                      method: .post,
                                      params: params,
                                      headers: HTTPHeaders(),
                                      completion: completionHandler)
    }
    
    /// Получить список ссылок
    /// - Parameter completionHandler: (ShorterLinksListResponse?, ErrorResponse?) -> Void
    func getShorterLinks(completionHandler: @escaping (ShorterLinksListResponse?, ErrorResponse?) -> Void) {
        self.networkLayer.requestData(ShorterLinksListResponse.self,
                                      authType: .auth,
                                      endpoint: .list,
                                      method: .get,
                                      params: nil,
                                      headers: HTTPHeaders(),
                                      completion: completionHandler)
    }
}
