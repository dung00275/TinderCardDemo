//  File name   : TinderCardDemoInteractor.swift
//
//  Author      : Dung Vu
//  Created date: 11/1/20
//  Version     : 1.00
//  --------------------------------------------------------------
//  
//  --------------------------------------------------------------

import RIBs
import RxSwift
import RxCocoa

protocol TinderCardDemoRouting: ViewableRouting {
    // todo: Declare methods the interactor can invoke to manage sub-tree via the router.
    func routeToDetail(_ source: Observable<[UserInfo]>)
}

protocol TinderCardDemoPresentable: Presentable {
    var listener: TinderCardDemoPresentableListener? { get set }

    // todo: Declare methods the interactor can invoke the presenter to present data.
}

protocol TinderCardDemoListener: class {
    // todo: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class TinderCardDemoInteractor: PresentableInteractor<TinderCardDemoPresentable> {
    /// Class's public properties.
    weak var router: TinderCardDemoRouting?
    weak var listener: TinderCardDemoListener?
    private let networkRequester: RequestNetworkProtocol
    /// Class's constructor.
    
    init(presenter: TinderCardDemoPresentable, networkRequester: RequestNetworkProtocol) {
        self.networkRequester = networkRequester
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: Class's public methods
    override func didBecomeActive() {
        super.didBecomeActive()
        setupRX()
        requestUsers()
        // todo: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // todo: Pause any business logic.
    }
    
    private func requestUsers() {
        networkRequester.request(using: Router.requestUser,
                                 decodeTo: UserResponse.self,
                                 block: nil)
            .bind(onNext: weakify({ (res, wSelf) in
                wSelf.mResponse = res
            })).disposeOnDeactivate(interactor: self)
    }

    /// Class's private properties.
    @Replay(queue: MainScheduler.asyncInstance) private var mResponse: Result<UserResponse, Error>
}

// MARK: TinderCardDemoInteractable's members
extension TinderCardDemoInteractor: TinderCardDemoInteractable, Weakifiable {
}

// MARK: TinderCardDemoPresentableListener's members
extension TinderCardDemoInteractor: TinderCardDemoPresentableListener {
    var response: Observable<Result<UserResponse, Error>> {
        return $mResponse
    }
    
    func routeToDetail() {
        let e = response.map { try $0.get().results }.filterNil()
        router?.routeToDetail(e)
    }
}

// MARK: Class's private methods
private extension TinderCardDemoInteractor {
    private func setupRX() {
        // todo: Bind data stream here.
    }
}
