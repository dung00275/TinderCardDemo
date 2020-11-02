//
//  TinderCardDemoTests.swift
//  TinderCardDemoTests
//
//  Created by Dung Vu on 10/30/20.
//

import XCTest
import RxSwift
import Alamofire
@testable import TinderCardDemo

struct File: APIRequestProtocol {
    var path: String
    var params: [String: Any]? { return nil }
    var header: [String: String]? { return nil }
    var method: HTTPMethod { return .get }
    var encoding: ParameterEncoding { return URLEncoding.default }
}

struct MockLoadFile: NetworkServiceProtocol {
    func request(using router: APIRequestProtocol) -> Observable<Result<NetworkResponse, Error>> {
        guard let pFileName = Bundle(for: TinderCardDemoTests.self).url(forResource: router.path, withExtension: "json") else {
            let e = NSError(domain: NSURLErrorDomain, code: NSURLErrorFileDoesNotExist, userInfo: [NSLocalizedDescriptionKey: "File Not exist."])
            return .just(.failure(e))
        }
        
        do {
            let data = try Data(contentsOf: pFileName)
            return .just(.success(NetworkResponse(response: nil, data: data)))
        } catch {
            return .just(.failure(error))
        }
    }
}

class TinderCardDemoTests: XCTestCase, Weakifiable {
    private var requester: NetworkRequester?
    private lazy var disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    private func loadMockupFileProvider() {
        requester = NetworkRequester(provider: MockLoadFile())
    }
    
    private func loadNetworkProvider() {
        requester = NetworkRequester(provider: Session.default)
    }
    
    func testGetNetworkData() {
        let expectation = XCTestExpectation(description: "Load request user api")
        loadNetworkProvider()
        requester?.request(using: Router.requestUser,
                          decodeTo: UserResponse.self)
            .bind(onNext: weakify({ (res, wSelf) in
                defer {
                    expectation.fulfill()
                }
                switch res {
                case .success(let res):
                    guard let r = res.results else {
                        return XCTAssert(false, "Load Fail")
                    }
                    XCTAssert(r.count >= 0, "Parse Fail")
                case .failure(let e):
                    XCTAssert(false, e.localizedDescription)
                }
                
        })).disposed(by: disposeBag)
        wait(for: [expectation], timeout: 30.0)
    }

    func testLoadLocalFileSuccess() {
        loadMockupFileProvider()
        requester?.request(using: File(path: "response"),
                          decodeTo: UserResponse.self)
            .bind(onNext: weakify({ (res, wSelf) in
                switch res {
                case .success(let res):
                    guard let r = res.results else {
                        return XCTAssert(false, "Load Fail")
                    }
                    XCTAssert(r.count == 50, "Parse Fail")
                case .failure(let e):
                    XCTAssert(false, e.localizedDescription)
                }
                
        })).disposed(by: disposeBag)
    }
    
    func testLoadLocalFileFailure() {
        loadMockupFileProvider()
        requester?.request(using: File(path: "abc"),
                          decodeTo: UserResponse.self)
            .bind(onNext: weakify({ (res, wSelf) in
                switch res {
                case .success:
                    XCTAssert(false, "Not exists")
                case .failure(let e):
                    print("!!! Success: \(e.localizedDescription)")
                }
        })).disposed(by: disposeBag)
    }
    
    func testLoadLocalFileNoData() {
        loadMockupFileProvider()
        requester?.request(using: File(path: "responseNoData"),
                          decodeTo: UserResponse.self)
            .bind(onNext: weakify({ (res, wSelf) in
                switch res {
                case .success:
                    XCTAssert(false, "Not exists")
                case .failure(let e):
                    print("!!! Success: \(e.localizedDescription)")
                }
        })).disposed(by: disposeBag)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
