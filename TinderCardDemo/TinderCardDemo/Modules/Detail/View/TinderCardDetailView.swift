//  File name   : TinderCardDetailView.swift
//
//  Author      : Dung Vu
//  Created date: 11/2/20
//  Version     : 1.00
//  --------------------------------------------------------------
//  
//  --------------------------------------------------------------

import UIKit
import SnapKit
final class TinderCardDetailView: UIView, UpdateDisplayProtocol, SwipeHandlerDirectionViewProtocol {
    /// Class's public properties.
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var lblName: UILabel?
    @IBOutlet var stateImageView: UIImageView?
    @IBOutlet var containerSegmentView: UIView?
    /// Class's private properties.
    
    func setupDisplay(_ value: UserInfo?) {
        imageView?.setImage(from: value?.picture, placeholder: UIImage(systemName: "person.circle.fill"), size: nil)
        lblName?.text = value?.name?.description
    }
    
    func handlerDirection(location: CGPoint, translation: CGPoint) {
        let direction = CardDirection.from(point: translation)
        guard let center = superview?.superview?.center, abs(center.x) > 0 else {
            return
        }
        let ratio = abs((location.x + translation.x)) / abs(center.x)
        let nextAlpha = min(ratio > 1 ? ratio : 1 - ratio, 1)
        stateImageView?.alpha = nextAlpha
        switch direction {
        case .left:
            stateImageView?.isHighlighted = true
        case .right:
            stateImageView?.isHighlighted = false
        default:
            break
        }
    }
    func cancelDragGesture() {
        stateImageView?.alpha = 0
    }
}

// MARK: Class's public methods
extension TinderCardDetailView {
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
        cancelDragGesture()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        visualize()
    }
}

// MARK: Class's private methods
private extension TinderCardDetailView {
    private func initialize() {
        // todo: Initialize view's here.
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        clipsToBounds = true
        
        let i1 = UIImage(systemName: "heart.fill")
        let i2 = UIImage(systemName: "heart.slash")
        stateImageView?.image = i2?.color(color: #colorLiteral(red: 0.3882352941, green: 0.4470588235, blue: 0.5019607843, alpha: 1))
        stateImageView?.highlightedImage = i1?.color(color: .red)
        
        let segment = CustomSegmentView<TinderItemInfoView, String>.init(edges: .zero, spacing: 0, axis: .horizontal, distribution: .fillEqually) { (_, nameImage) -> TinderItemInfoView in
            let v = TinderItemInfoView.loadXib()
            v.setupDisplay(nameImage)
            return v
        }
        
        segment >>> containerSegmentView >>> {
            $0.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
        segment.setupDisplay(["person.fill", "calendar", "location.fill", "phone.fill", "info.circle.fill"])
        segment.select(at: 0)
    }
    private func visualize() {
        // todo: Visualize view's here.
    }
}
