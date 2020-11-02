//  File name   : TinderCardDemoComponent+TinderCardDetail.swift
//
//  Author      : Dung Vu
//  Created date: 11/2/20
//  Version     : 1.00
//  --------------------------------------------------------------
//  
//  --------------------------------------------------------------

import RIBs

/// The dependencies needed from the parent scope of TinderCardDemo to provide for the TinderCardDetail scope.
// todo: Update TinderCardDemoDependency protocol to inherit this protocol.
protocol TinderCardDemoDependencyTinderCardDetail: Dependency {
    // todo: Declare dependencies needed from the parent scope of TinderCardDemo to provide dependencies
    // for the TinderCardDetail scope.
}

extension TinderCardDemoComponent: TinderCardDetailDependency {

    // todo: Implement properties to provide for TinderCardDetail scope.
}
