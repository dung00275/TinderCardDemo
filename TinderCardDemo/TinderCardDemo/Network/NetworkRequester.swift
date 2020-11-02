//  File name   : NetworkRequester.swift
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

struct Router: APIRequestProtocol {
    static let host = "https://randomuser.me"
    static let requestUser: Router = {
        #if DEBUG
        let p = urlArgument ?? "/api"
        return Router(path: host + p, params: ["results": loadNumberItems], header: nil)
        #else
        return Router(path: host + "/api", params: ["results": 50], header: nil)
        #endif
    }()
    
    var path: String
    var params: [String: Any]?
    var header: [String: String]?
    var method: HTTPMethod = .get
    var encoding: ParameterEncoding = URLEncoding.default
}

extension Session: NetworkServiceProtocol {
    public func request(using router: APIRequestProtocol) -> Observable<Result<NetworkResponse, Error>> {
        return Observable.create { (s) -> Disposable in
            let headers = HTTPHeaders.init(use: router.header)
            let task = self.request(router.path,
                                    method: router.method,
                                    parameters: router.params,
                                    encoding: router.encoding, headers: headers)
            task.validate(statusCode: 200..<300).responseData { data in
                let result = data.result
                defer {
                    s.onCompleted()
                }
                switch result {
                case .success(let value):
                    s.onNext(.success((data.response, value)))
                case .failure(let e):
                    s.onNext(.failure(e))
                }
            }
            
            task.resume()
            return Disposables.create {
                guard !task.isFinished else { return }
                task.cancel()
            }
        }
    }
}

struct NetworkRequester: RequestNetworkProtocol {
    static let `default` = NetworkRequester(provider: Session.default)
    var provider: NetworkServiceProtocol
    init(provider: NetworkServiceProtocol) {
        self.provider = provider
    }
    
    func request<T>(using router: APIRequestProtocol,
                    decodeTo: T.Type,
                    block: ((JSONDecoder) -> Void)? = nil) -> Observable<Result<T, Error>> where T : Decodable {
        #if DEBUG
        if loadFile {
            guard let url = Bundle.main.url(forResource: "responseDummy", withExtension: "json") else {
                let e = NSError(domain: NSURLErrorDomain, code: NSURLErrorFileDoesNotExist, userInfo: [NSLocalizedDescriptionKey: "File Not exist."])
                return .just(.failure(e))
            }
            
            let r = Result { () -> T in
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                return result
            }
            return .just(r)
        }
        #endif
        return provider.request(using: router).map { response -> Result<T, Error> in
            Swift.Result {
                let r = try response.get()
                let decoder = JSONDecoder()
                block?(decoder)
                return try decoder.decode(T.self, from: r.data)
            }
        }
    }
}

