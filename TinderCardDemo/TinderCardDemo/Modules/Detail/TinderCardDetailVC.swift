//  File name   : TinderCardDetailVC.swift
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
import SnapKit

protocol TinderCardDetailPresentableListener: class {
    // todo: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    var source: Observable<[UserInfo]> { get }
}

final class TinderCardDetailVC: UIViewController, TinderCardDetailPresentable, TinderCardDetailViewControllable {
    private struct Config {
    }
    
    /// Class's public properties.
    weak var listener: TinderCardDetailPresentableListener?

    // MARK: View's lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localize()
    }

    /// Class's private properties.
}

// MARK: View's event handlers
extension TinderCardDetailVC {
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

// MARK: Class's public methods
extension TinderCardDetailVC {
}

// MARK: Class's private methods
private extension TinderCardDetailVC {
    private func localize() {
        // todo: Localize view's here.
    }
    private func visualize() {
        // todo: Visualize view's here.
        let edge = view.safeAreaInsets
        let tinderCardView = TinderCardSwipeView<TinderCardDetailView>.init(using: UIEdgeInsets(top: edge.top + 40, left: 30, bottom: edge.bottom + 50, right: 30), maxInvisible: 5) { [weak self] (idx) -> Observable<TinderCardDetailView?> in
            guard let wSelf = self, let listener = wSelf.listener else { return .empty() }
            return listener.source.take(1).map { items -> TinderCardDetailView? in
                guard let i = items[safe: idx] else { return nil }
                let v = TinderCardDetailView.loadXib()
                v.setupDisplay(i)
                return v
            }
        }
        
        tinderCardView >>> view >>> {
            $0.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
        DispatchQueue.main.async {
            tinderCardView.loadView()
        }
    }
}
