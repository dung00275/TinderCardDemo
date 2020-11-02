//  File name   : TinderCardDetailRouter.swift
//
//  Author      : Dung Vu
//  Created date: 11/1/20
//  Version     : 1.00
//  --------------------------------------------------------------
//  
//  --------------------------------------------------------------

import RIBs

protocol TinderCardDetailInteractable: Interactable {
    var router: TinderCardDetailRouting? { get set }
    var listener: TinderCardDetailListener? { get set }
}

protocol TinderCardDetailViewControllable: ViewControllable {
    // todo: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TinderCardDetailRouter: ViewableRouter<TinderCardDetailInteractable, TinderCardDetailViewControllable> {
    /// Class's constructor.
    override init(interactor: TinderCardDetailInteractable, viewController: TinderCardDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: Class's public methods
    override func didLoad() {
        super.didLoad()
    }
    
    /// Class's private properties.
}

// MARK: TinderCardDetailRouting's members
extension TinderCardDetailRouter: TinderCardDetailRouting {
    
}

// MARK: Class's private methods
private extension TinderCardDetailRouter {
}
