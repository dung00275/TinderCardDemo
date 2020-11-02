//  File name   : TinderCardDetailInteractor.swift
//
//  Author      : Dung Vu
//  Created date: 11/1/20
//  Version     : 1.00
//  --------------------------------------------------------------
//  
//  --------------------------------------------------------------

import RIBs
import RxSwift

protocol TinderCardDetailRouting: ViewableRouting {
    // todo: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TinderCardDetailPresentable: Presentable {
    var listener: TinderCardDetailPresentableListener? { get set }

    // todo: Declare methods the interactor can invoke the presenter to present data.
}

protocol TinderCardDetailListener: class {
    // todo: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class TinderCardDetailInteractor: PresentableInteractor<TinderCardDetailPresentable> {
    /// Class's public properties.
    weak var router: TinderCardDetailRouting?
    weak var listener: TinderCardDetailListener?

    /// Class's constructor.
    init(presenter: TinderCardDetailPresentable, source: Observable<[UserInfo]>) {
        self.mSource = source
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: Class's public methods
    override func didBecomeActive() {
        super.didBecomeActive()
        setupRX()
        
        // todo: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // todo: Pause any business logic.
    }

    /// Class's private properties.
    let mSource: Observable<[UserInfo]>
}

// MARK: TinderCardDetailInteractable's members
extension TinderCardDetailInteractor: TinderCardDetailInteractable {
}

// MARK: TinderCardDetailPresentableListener's members
extension TinderCardDetailInteractor: TinderCardDetailPresentableListener {
    var source: Observable<[UserInfo]> {
        return mSource
    }
}

// MARK: Class's private methods
private extension TinderCardDetailInteractor {
    private func setupRX() {
        // todo: Bind data stream here.
    }
}
