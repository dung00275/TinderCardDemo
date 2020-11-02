//  File name   : TinderCardDemoRouter.swift
//
//  Author      : Dung Vu
//  Created date: 11/1/20
//  Version     : 1.00
//  --------------------------------------------------------------
//  
//  --------------------------------------------------------------

import RIBs
import RxSwift

protocol TinderCardDemoInteractable: Interactable, TinderCardDetailListener {
    var router: TinderCardDemoRouting? { get set }
    var listener: TinderCardDemoListener? { get set }
}

protocol TinderCardDemoViewControllable: ViewControllable {
    // todo: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TinderCardDemoRouter: LaunchRouter<TinderCardDemoInteractable, TinderCardDemoViewControllable> {
    /// Class's constructor.
    init(interactor: TinderCardDemoInteractable, tinderCardDetailBuildable: TinderCardDetailBuildable, viewController: TinderCardDemoViewControllable) {
        self.tinderCardDetailBuildable = tinderCardDetailBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: Class's public methods
    override func didLoad() {
        super.didLoad()
    }
    
    /// Class's private properties.
    private let tinderCardDetailBuildable: TinderCardDetailBuildable
}

// MARK: TinderCardDemoRouting's members
extension TinderCardDemoRouter: TinderCardDemoRouting {
    func routeToDetail(_ source: Observable<[UserInfo]>) {
        let route = tinderCardDetailBuildable.build(withListener: interactor, source: source)
        let segue = RibsRouting(use: route, transitionType: .modal(type: .crossDissolve, presentStyle: .overCurrentContext) , needRemoveCurrent: true )
        perform(with: segue, completion: nil)
    }
}

// MARK: Class's private methods
private extension TinderCardDemoRouter {
}
