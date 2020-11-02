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
    func requestUsers()
}

final class TinderCardDemoVC: UIViewController, TinderCardDemoPresentable, TinderCardDemoViewControllable {
    private struct Config {
    }

    /// Class's public properties.
    weak var listener: TinderCardDemoPresentableListener?
    private lazy var disposeBag = DisposeBag()
    // MARK: View's lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
        view.backgroundColor = .yellow
        setupRX()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    func localize() {}
    func visualize() {}
    
    private func handlerError(_ e: Error) {
        let actionRetry = UIAlertAction(title: "Retry", style: .cancel, handler: weakify({ (_, wSelf) in
            wSelf.listener?.requestUsers()
        }))
        let alertVC = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .alert)
        alertVC.addAction(actionRetry)
        present(alertVC, animated: true, completion: nil)
    }
    
    func setupRX() {
        listener?.response.bind(onNext: weakify({ (res, wSelf) in
            switch res {
            case .success:
                wSelf.listener?.routeToDetail()
            case .failure(let e):
                wSelf.handlerError(e)
            }
        })).disposed(by: disposeBag)
    }
}
