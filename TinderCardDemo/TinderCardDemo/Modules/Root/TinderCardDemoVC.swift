//  File name   : TinderCardDemoVC.swift
//
//  Author      : Dung Vu
//  Created date: 11/1/20
//  Version     : 1.00
//  --------------------------------------------------------------
//  
//  --------------------------------------------------------------

import RIBs
import UIKit
import RxSwift
import RxCocoa

protocol TinderCardDemoPresentableListener: class {
    // todo: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    var response: Observable<Result<UserResponse, Error>> { get }
    func routeToDetail()
}

final class TinderCardDemoVC: UIViewController, TinderCardDemoPresentable, TinderCardDemoViewControllable {
    private struct Config {
    }

    /// Class's public properties.
    weak var listener: TinderCardDemoPresentableListener?

    // MARK: View's lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
        view.backgroundColor = .yellow
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listener?.routeToDetail()
    }

    /// Class's private properties.
}

// MARK: View's event handlers
extension TinderCardDemoVC {
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

// MARK: Class's public methods
extension TinderCardDemoVC {
}

// MARK: Class's private methods
private extension TinderCardDemoVC {
    private func localize() {
        // todo: Localize view's here.
    }
    private func visualize() {
        // todo: Visualize view's here.
    }
    
    func setupRX() {
        
    }
}
