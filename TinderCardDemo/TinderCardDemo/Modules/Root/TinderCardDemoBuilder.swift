//  File name   : TinderCardDemoBuilder.swift
//
//  Author      : Dung Vu
//  Created date: 11/1/20
//  Version     : 1.00
//  --------------------------------------------------------------
//  
//  --------------------------------------------------------------

import RIBs

// MARK: Dependency tree
protocol TinderCardDemoDependency: Dependency {
    // todo: Declare the set of dependencies required by this RIB, but cannot be created by this RIB.
    var networkRequester: RequestNetworkProtocol { get }
}

final class TinderCardDemoComponent: Component<TinderCardDemoDependency> {
    /// Class's public properties.
    let TinderCardDemoVC: TinderCardDemoVC
    
    /// Class's constructor.
    init(dependency: TinderCardDemoDependency, TinderCardDemoVC: TinderCardDemoVC) {
        self.TinderCardDemoVC = TinderCardDemoVC
        super.init(dependency: dependency)
    }
    
    /// Class's private properties.
    // todo: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: Builder
protocol TinderCardDemoBuildable: Buildable {
    func build() -> LaunchRouting
}

final class TinderCardDemoBuilder: Builder<TinderCardDemoDependency>, TinderCardDemoBuildable {
    /// Class's constructor.
    override init(dependency: TinderCardDemoDependency) {
        super.init(dependency: dependency)
    }
    
    // MARK: TinderCardDemoBuildable's members
    func build() -> LaunchRouting {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? TinderCardDemoVC else {
            fatalError("Please implement!!!!")
        }
        let component = TinderCardDemoComponent(dependency: dependency, TinderCardDemoVC: vc)

        let interactor = TinderCardDemoInteractor(presenter: component.TinderCardDemoVC, networkRequester: component.dependency.networkRequester)

        // todo: Create builder modules builders and inject into router here.
        let tinderCardDetailBuilder = TinderCardDetailBuilder(dependency: component)
        return TinderCardDemoRouter(interactor: interactor, tinderCardDetailBuildable: tinderCardDetailBuilder, viewController: component.TinderCardDemoVC)
    }
}
