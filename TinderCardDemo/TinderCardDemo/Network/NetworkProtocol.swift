//  File name   : NetworkProtocol.swift
//
//  Author      : Dung Vu
//  Created date: 11/1/20
//  Version     : 1.00
//  --------------------------------------------------------------
//  
//  --------------------------------------------------------------

import Foundation
import Alamofire
import RxSwift

public protocol APIRequestProtocol {
    var path: String { get }
    var params: [String: Any]? { get }
    var header: [String: String]? { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
}

public typealias NetworkResponse = (response: HTTPURLResponse?, data: Data)
public protocol NetworkServiceProtocol {
    func request(using router: APIRequestProtocol) -> Observable<Swift.Result<NetworkResponse, Error>>
}

// MARK: - Requester Protocol
public protocol RequestNetworkProtocol {
    var provider: NetworkServiceProtocol { get }
    init(provider: NetworkServiceProtocol)
    func request<T: Decodable>(using router: APIRequestProtocol,
                               decodeTo: T.Type,
                               block: ((JSONDecoder) -> Void)?) -> Observable<Swift.Result<T, Error>>
}

extension HTTPHeaders {
    init?(use headers: [String: String]?) {
        guard let h = headers else { return nil }
        self.init(h)
    }
}
