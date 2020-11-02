//
//  TinderCardSwipeView.swift
//  TinderCardDemo
//
//  Created by Dung Vu on 10/30/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TinderCardSwipeView<ContentView>: UIView, TinderManagerViewDelegateProtocol, Weakifiable where ContentView: UIView, ContentView: SwipeHandlerDirectionViewProtocol {
    typealias TinderCardLoadContentView = (_ idx: Int) -> Observable<ContentView?>
    private var edge: UIEdgeInsets = .zero
    private var maxInvisible = 5
    private var allowDirection: CardDirection = .horizontal
    private lazy var disposeBag = DisposeBag()
    
    private lazy var containerView: UIView = UIView(frame: .zero)
    private lazy var miscContainerView = UIView(frame: .zero)
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self)
    private lazy var viewManagers: [UIView: TinderManagerViewGesture<ContentView>] = [:]
    
    private var currentIdx: Int = -1 {
        didSet {
            guard currentIdx > oldValue else {
                return
            }
            findNextView()
        }
    }
    
    private var loadNext: TinderCardLoadContentView?
    
    convenience init(using edge: UIEdgeInsets,
                     maxInvisible: Int = 5,
                     allowDirection: CardDirection = .horizontal,
                     item: TinderCardLoadContentView?) {
        self.init(frame: .zero)
        self.edge = edge
        self.maxInvisible = maxInvisible
        self.allowDirection = allowDirection
        self.loadNext = item
        visualize()
    }
    
    private func visualize() {
        backgroundColor = .clear
        containerView >>> self >>> {
            $0.backgroundColor = .clear
            $0.snp.makeConstraints { (make) in
                make.edges.equalTo(edge)
            }
        }
        addSubview(miscContainerView)
    }
    
    private func findNextView() {
        guard let next = loadNext?(currentIdx) else {
            currentIdx -= 1
            return
        }
        next.take(1).bind(onNext: weakify({ (n, wSelf) in
            guard let n = n else {
                wSelf.currentIdx -= 1
                return
            }
            wSelf.insert(view: n)
        })).disposed(by: disposeBag)
    }
    
    func insert(view: ContentView) {
        let total = viewManagers.keys.count
        guard total < maxInvisible else {
            currentIdx -= 1
            return
        }
        
        containerView.insertSubview(view, at: 0)
        view >>> {
            $0.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        let manager = TinderManagerViewGesture<ContentView>.init(view: view, containerView: containerView, miscView: miscContainerView, animator: animator, allowDirection: allowDirection, delegate: self)
        viewManagers[view] = manager
        updateAnimateView { [weak self] (_) in
            self?.currentIdx += 1
        }
    }
    
    private func updateAnimateView(_ completion: ((Bool) -> Void)?) {
        containerView.subviews.compactMap { $0 as? ContentView }.reversed().enumerated().forEach { (i) in
            i.element.isUserInteractionEnabled = i.offset == 0
            animateInsert(view: i.element, at: i.offset, completion: nil)
        }
        completion?(true)
    }
    
    private func animateInsert(view: UIView, at index: Int, completion: ((Bool) -> Void)?) {
        let t1 = CGAffineTransform(translationX: 0, y: CGFloat(index * 5))
        let t2 = CGAffineTransform(scaleX: 1 - CGFloat(index) * 0.05, y: 1)
        let transform = t1.concatenating(t2)
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
            view.transform = transform
        }, completion: completion)
    }
    
    func loadView() {
        updateAnimateView(nil)
        self.currentIdx += 1
    }
        
    // MARK: -- Delegate
    func didRemove(view: UIView, location: CGPoint, direction: CGVector) {
        viewManagers.removeValue(forKey: view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: loadView)
    }
}

