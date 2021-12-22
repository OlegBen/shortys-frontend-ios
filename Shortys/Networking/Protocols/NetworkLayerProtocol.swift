//
//  NetworkLayerProtocol.swift
//  Shortys
//
//  Created by user on 22.12.2021.
//

import Foundation
import Alamofire

// MARK: NetworkLayerProtocol
protocol NetworkLayerProtocol {
    var host: String { get }
    var session: Session { get set }
    
    init(session: Session)
    
    func makeUnAuthHeaders() -> HTTPHeaders
    func makeAuthHeaders() -> HTTPHeaders
    func requestData<T: Codable>(_ classToReturn: T.Type, authType: AuthType, endpoint: Endpoint, method: HTTPMethod, params: Parameters?, headers: HTTPHeaders, encoding: ParameterEncoding, completion: @escaping ((T?, ErrorResponse?) -> Void))
    func requestData<T: Codable>(_ classToReturn: T.Type, authType: AuthType, endpoint: Endpoint, method: HTTPMethod, params: Parameters?,headers: HTTPHeaders, encoding: ParameterEncoding, completion: @escaping ((T?, ErrorResponse?, [String: Any]) -> Void))
    func requestWithQuery<T: Codable>(_ classToReturn: T.Type, authType: AuthType, endpoint: Endpoint, method: HTTPMethod, params: Parameters?,headers: HTTPHeaders, encoding: ParameterEncoding, completion: @escaping ((T?, ErrorResponse?, [String: Any]) -> Void))
    
    func requestData<T: Codable>(url: String, method: HTTPMethod, params: Parameters?, headers: HTTPHeaders, encoding: ParameterEncoding, completion: @escaping ((T?, ErrorResponse?)->Void))
    func requestData<T: Codable>(url: String, method: HTTPMethod, params: Parameters?, headers: HTTPHeaders, encoding: ParameterEncoding, completion: @escaping ((T?, ErrorResponse?, [String: Any])->Void))
    func requestWithQuery<T: Codable>(url: String, method: HTTPMethod, params: Parameters?, headers: HTTPHeaders, encoding: ParameterEncoding, completion: @escaping ((T?, ErrorResponse?, [String: Any])->Void))
}
