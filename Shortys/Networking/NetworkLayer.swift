//
//  NetworkLayer.swift
//  Shortys
//
//  Created by user on 22.12.2021.
//

import Foundation
import Alamofire

// MARK: NetworkLayer
final class NetworkLayer: NetworkLayerProtocol, BaseAPI {
    /// Домен, начало ссылки в запросе
    internal var host: String {
        get {
            return NetworkConstants.host
        }
    }
    var session: Session
    
    
    /// Инициализатор
    /// - Parameter session: Session
    init(session: Session) {
        self.session = session
    }
    
    /// Конструктор заголовков для неавторизованного запроса
    /// - Returns: Готовые заголовки для запроса
    internal func makeUnAuthHeaders() -> HTTPHeaders {
        var headers:[HTTPHeader] = [HTTPHeader]()
        headers.append(HTTPHeader(name: NetworkConstants.contentType, value: NetworkConstants.appJson))
        return HTTPHeaders(headers)
    }
    
    /// Конструктор заголовков для авторизованного запроса
    /// - Returns: Готовые заголовки для запроса
    internal func makeAuthHeaders() -> HTTPHeaders {
        var headers = makeUnAuthHeaders()
        headers.add(HTTPHeader(name: NetworkConstants.authorization, value: NetworkConstants.token))
        return headers
    }
    
    func mergeHeaders(headers: HTTPHeaders, authType: AuthType) -> HTTPHeaders {
        switch authType {
        case .noAuth:
            var modHeaders = makeUnAuthHeaders()
            for header in headers {
                modHeaders.add(header)
            }
            return modHeaders
        case .auth:
            var modHeaders = makeAuthHeaders()
            for header in headers {
                modHeaders.add(header)
            }
            return modHeaders
        }
    }
    
    //MARK: Requests
    /// Универсальный запрос с указанием возвращаемого типа
    func requestData<T: Codable>(_ classToReturn: T.Type, authType: AuthType, endpoint: Endpoint, method: HTTPMethod, params: Parameters?, headers: HTTPHeaders, encoding: ParameterEncoding = JSONEncoding.default, completion: @escaping ((T?, ErrorResponse?) -> Void)) {
        let headers = self.mergeHeaders(headers: headers, authType: authType)
        let host = self.host
        self.requestData(url: host + endpoint.rawValue, method: method, params: params, headers: headers, encoding: encoding, completion: completion)
    }

    func requestData<T: Codable>(_ classToReturn: T.Type, authType: AuthType, endpoint: Endpoint, method: HTTPMethod, params: Parameters?, headers: HTTPHeaders, encoding: ParameterEncoding = JSONEncoding.default, completion: @escaping ((T?, ErrorResponse?, [String: Any]) -> Void)) {
        let headers = self.mergeHeaders(headers: headers, authType: authType)
        requestData(url: host + endpoint.rawValue, method: method, params: params, headers: headers,  encoding: encoding, completion: completion)
    }
    
    func requestWithQuery<T: Codable>(_ classToReturn: T.Type, authType: AuthType, endpoint: Endpoint, method: HTTPMethod, params: Parameters?,headers: HTTPHeaders, encoding: ParameterEncoding = URLEncoding(destination: .queryString), completion: @escaping ((T?, ErrorResponse?, [String: Any]) -> Void)) {
        let headers = self.mergeHeaders(headers: headers, authType: authType)
        requestWithQuery(url: host + endpoint.rawValue, method: method, params: params, headers: headers,  encoding: encoding, completion: completion)
    }
    
    /// Метод для получения объекта
    /// - Parameter url: URL-ссылка для запроса
    /// - Parameter method: Метод запроса (GET, POST и т.д.)
    /// - Parameter params: Параметры для запроса, можно передавать обычный словарь
    /// - Parameter headers: Заголовки для запроса, словарь [String: String]
    /// - Parameter completion: Обработка полученного объекта
    func requestData<T: Codable>(url: String, method: HTTPMethod = .get, params: Parameters? = nil, headers: HTTPHeaders, encoding: ParameterEncoding, completion: @escaping ((T?, ErrorResponse?)->Void)) {
        print("🪐🪐🪐", method.rawValue, url)
        print("Headers: \n", headers)
        print("Params: \n", params)
        self.session.request(url, method: method, parameters: params, encoding: encoding, headers: headers).response(queue: .global(qos: .background)) { [weak self] (response) in
            guard let _self = self else {
                completion(nil, nil)
                return
            }
            
            guard let data = response.data else {
                let error = ErrorResponse(error: "Oops", errorDescription: "No data in response")
                completion(nil, error)
                return
            }
            
            let results = _self.tryToParseResponse(parseType: T.self, data: data)
            print("Response: \n", results)
            completion(results.0, results.1)
        }
    }
    
    func requestData<T: Codable>(url: String, method: HTTPMethod, params: Parameters?, headers: HTTPHeaders, encoding: ParameterEncoding, completion: @escaping ((T?, ErrorResponse?, [String: Any])->Void)) {
        print("🪐🪐🪐", method.rawValue, url)
        print("Headers: \n", headers)
        print("Params: \n", params)
        self.session.request(url, method: method, parameters: params, encoding: encoding, headers: headers).response(queue: .global(qos: .background)) { [weak self] (response) in
            guard let _self = self else {
                completion(nil, nil, [:])
                return
            }
            
            var anyParams: [String: Any] = [:]
            if let headerFields = response.response?.allHeaderFields as? [String: String], let url = response.request?.url {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
                anyParams["Cookies"] = cookies
            }
            
            guard let data = response.data else {
                let error = ErrorResponse(error: "Oops", errorDescription: "No data in response")
                completion(nil, error, anyParams)
                return
            }
            
            let results = _self.tryToParseResponse(parseType: T.self, data: data)
            print("Response: \n", results)
            completion(results.0, results.1, anyParams)
            
        }
    }
    
    /// Метод для получения объекта
    /// - Parameter url: URL-ссылка для запроса
    /// - Parameter method: Метод запроса (GET, POST и т.д.)
    /// - Parameter params: Параметры для запроса, можно передавать обычный словарь
    /// - Parameter headers: Заголовки для запроса, словарь [String: String]
    /// - Parameter completion: Обработка полученного объекта
    func requestWithQuery<T: Codable>(url: String, method: HTTPMethod = .get, params: Parameters? = nil, headers: HTTPHeaders, encoding: ParameterEncoding, completion: @escaping ((T?, ErrorResponse?, [String: Any])->Void)) {
        print("🪐🪐🪐", method.rawValue, url)
        print("Headers: \n", headers)
        print("Params: \n", params)
        self.session.request(url, method: method, parameters: params, encoding: encoding, headers: headers).response(queue: .global(qos: .background)) { [weak self] (response) in
            guard let _self = self else {
                completion(nil, nil, [:])
                return
            }
            
            var anyParams: [String: Any] = [:]
            if let headerFields = response.response?.allHeaderFields as? [String: String] {
                anyParams = headerFields
            }
            
            guard let data = response.data else {
                let error = ErrorResponse(error: "Oops", errorDescription: "No data in response")
                completion(nil, error, anyParams)
                return
            }
            
            let results = _self.tryToParseResponse(parseType: T.self, data: data)
            print("Response: \n", results)
            completion(results.0, results.1, anyParams)
        }
    }
    
    private func tryToParseResponse<T: Codable>(parseType: T.Type, data: Data) -> (T?, ErrorResponse?) {
        do {
            let responseObject = try JSONDecoder().decode(T.self, from: data)
            return (responseObject, nil)
        } catch {
            do {
                let responseError = try JSONDecoder().decode(ErrorResponse.self, from: data)
                return (nil, responseError)
            } catch {
                let error = ErrorResponse(error: "Wrong type", errorDescription: "Response data has wrong type")
                return (nil, error)
            }
        }
    }
    
    static func getSession() -> Session {
        let manager = Session()
        return manager
    }
    
}

// MARK: TheResponse
fileprivate class TheResponse<T:Codable>: Codable {
    var data: T?
}
