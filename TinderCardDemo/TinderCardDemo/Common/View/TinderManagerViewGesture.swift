//  File name   : TinderManagerViewGesture.swift
//
//  Author      : Dung Vu
//  Created date: 10/30/20
//  Version     : 1.00
//  --------------------------------------------------------------
//  
//  --------------------------------------------------------------

import UIKit
import RxSwift
import RxCocoa

// MARK: -- Delegate
protocol TinderManagerViewDelegateProtocol: AnyObject {
    func didRemove(view: UIView, location: CGPoint, direction: CGVector)
}

// MARK: -- Manage behavior swipe
final class TinderManagerViewGesture<ContentView>: Weakifiable where ContentView: UIView, ContentView: SwipeHandlerDirectionViewProtocol  {
        
    private let containerView: UIView
    private let miscContainerView: UIView
    private let view: ContentView
    
    private let animator: UIDynamicAnimator
    private var snapBehavior: UISnapBehavior?
    private var viewToAnchor: UIAttachmentBehavior?
    private var anchorViewToPoint: UIAttachmentBehavior?
    private var pushBehavior: UIPushBehavior?
    
    private let minTranslation: CGFloat = 0.25
    private let minVelocity: CGFloat = 750
    private let allowDirection: CardDirection
    private lazy var disposeBag = DisposeBag()
    
    private weak var delegate: TinderManagerViewDelegateProtocol?
    private lazy var anchorView = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
    private lazy var panGesture: UIPanGestureRecognizer = .init(target: nil, action: nil)
    
    init(view: ContentView,
         containerView: UIView,
         miscView: UIView,
         animator: UIDynamicAnimator,
         allowDirection: CardDirection,
         delegate: TinderManagerViewDelegateProtocol?) {
        self.view = view
        self.animator = animator
        self.containerView = containerView
        self.miscContainerView = miscView
        self.allowDirection = allowDirection
        self.delegate = delegate
        miscContainerView.addSubview(anchorView)
        addGesture()
        setupRX()
    }
    
    private func addBehavior(_ b: UIDynamicBehavior?) {
        guard let b = b else {
            return
        }
        animator.addBehavior(b)
    }
    
    private func removeBehavior(_ items: UIDynamicBehavior?...) {
        items.compactMap { $0 }.forEach {
            animator.removeBehavior($0)
        }
    }
    
    private func addSnapContainer() {
        let p = containerView.center
        self.snapBehavior = UISnapBehavior(item: view, snapTo: p)
        self.snapBehavior?.damping = 0.75
        addBehavior(snapBehavior)
    }
    
    private func addGesture() {
        view.addGestureRecognizer(panGesture)
    }
    
    private func attachView(_ point: CGPoint) {
        anchorView.center = point
        anchorView.isHidden = true
        
        let pCenter = view.center
        viewToAnchor = UIAttachmentBehavior(item: view,
                                            offsetFromCenter: UIOffset(horizontal: -(pCenter.x - point.x), vertical: -(pCenter.y - point.y)),
                                            attachedTo: anchorView,
                                            offsetFromCenter: UIOffset.zero)
        viewToAnchor?.length = 0

        anchorViewToPoint = UIAttachmentBehavior(item: anchorView,
                                                 offsetFromCenter: UIOffset.zero,
                                                 attachedToAnchor: point)
        anchorViewToPoint?.damping = 100
        anchorViewToPoint?.length = 0
        
        addBehavior(viewToAnchor)
        addBehavior(anchorViewToPoint)
    }
    
    private func pushView(from point: CGPoint, direction: CGVector) {
        removeBehavior(anchorViewToPoint)
        pushBehavior = UIPushBehavior(items: [anchorView], mode: .instantaneous)
        pushBehavior?.pushDirection = direction
        addBehavior(pushBehavior)
    }
    
    private func moveView(to point: CGPoint) {
        anchorViewToPoint?.anchorPoint = point
    }
    
    private func detachView() {
        removeBehavior(viewToAnchor, anchorViewToPoint)
    }
    
    private func shouldSwipe(translation: CGPoint, velocity: CGPoint) -> Bool {
        guard let bounds = containerView.superview?.bounds else {
            return false
        }
        
        let c1 = CGPoint.sameDirection(translation, p2: velocity)
        let c2 = CardDirection.from(point: translation).intersection(allowDirection) != .none
        let c3 = abs(translation.x) > minTranslation * bounds.width || abs(translation.y) > minTranslation * bounds.height
        let c4 = velocity.magnitude > minVelocity
        return c1 && c2 && (c3 || c4)
    }
    
    private func setupRX() {
        panGesture.rx.event.bind(onNext: weakify({ (gesture, wSelf) in
            let state = gesture.state
            let translation = gesture.translation(in: wSelf.containerView)
            let location = gesture.location(in: wSelf.containerView)
            let velocity = gesture.velocity(in: wSelf.containerView)
            
            switch state {
            case .began:
                wSelf.removeBehavior(wSelf.snapBehavior)
                wSelf.attachView(location)
            case .changed:
                wSelf.view.handlerDirection(location: location, translation: translation)
                wSelf.moveView(to: location)
            case .ended, .cancelled:
                if wSelf.shouldSwipe(translation: translation, velocity: velocity) {
                    let p = translation.normalized * max(velocity.magnitude, wSelf.minVelocity)
                    let direction = CGVector(dx: p.x, dy: p.y)
                    wSelf.pushView(from: location, direction: direction)
                    wSelf.delegate?.didRemove(view: wSelf.view, location: location, direction: direction)
                } else {
                    wSelf.detachView()
                    wSelf.addSnapContainer()
                    wSelf.view.cancelDragGesture()
                }
            default:
                break
            }
        })).disposed(by: disposeBag)
    }
    
    deinit {
        removeBehavior(snapBehavior, viewToAnchor, anchorViewToPoint, pushBehavior)
        view.removeGestureRecognizer(panGesture)
        anchorView.removeFromSuperview()
        view.removeFromSuperview()
    }
}

