//  File name   : TinderCardDetailBuilder.swift
//
//  Author      : Dung Vu
//  Created date: 11/1/20
//  Version     : 1.00
//  --------------------------------------------------------------
//  
//  --------------------------------------------------------------

import RIBs
import RxSwift
// MARK: Dependency tree
protocol TinderCardDetailDependency: Dependency {
    // todo: Declare the set of dependencies required by this RIB, but cannot be created by this RIB.
}

final class TinderCardDetailComponent: Component<TinderCardDetailDependency> {
    /// Class's public properties.
    let TinderCardDetailVC: TinderCardDetailVC
    
    /// Class's constructor.
    init(dependency: TinderCardDetailDependency, TinderCardDetailVC: TinderCardDetailVC) {
        self.TinderCardDetailVC = TinderCardDetailVC
        super.init(dependency: dependency)
    }
    
    /// Class's private properties.
    // todo: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: Builder
protocol TinderCardDetailBuildable: Buildable {
    func build(withListener listener: TinderCardDetailListener, source: Observable<[UserInfo]>) -> TinderCardDetailRouting
}

final class TinderCardDetailBuilder: Builder<TinderCardDetailDependency>, TinderCardDetailBuildable {
    /// Class's constructor.
    override init(dependency: TinderCardDetailDependency) {
        super.init(dependency: dependency)
    }
    
    // MARK: TinderCardDetailBuildable's members
    func build(withListener listener: TinderCardDetailListener, source: Observable<[UserInfo]>) -> TinderCardDetailRouting {
        let vc = TinderCardDetailVC()
        let component = TinderCardDetailComponent(dependency: dependency, TinderCardDetailVC: vc)

        let interactor = TinderCardDetailInteractor(presenter: component.TinderCardDetailVC, source: source)
        interactor.listener = listener

        // todo: Create builder modules builders and inject into router here.
        
        return TinderCardDetailRouter(interactor: interactor, viewController: component.TinderCardDetailVC)
    }
}
