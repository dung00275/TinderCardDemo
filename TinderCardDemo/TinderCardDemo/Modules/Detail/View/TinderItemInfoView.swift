//  File name   : TinderItemInfoView.swift
//
//  Author      : Dung Vu
//  Created date: 11/2/20
//  Version     : 1.00
//  --------------------------------------------------------------
//  
//  --------------------------------------------------------------

import UIKit

final class TinderItemInfoView: UIView, SegmentChildProtocol, UpdateDisplayProtocol {
    /// Class's public properties.
    @IBOutlet var indicator: UIView?
    @IBOutlet var imageView: UIImageView?
    /// Class's private properties.
    var isSelected: Bool = false {
        didSet {
            imageView?.isHighlighted = isSelected
            indicator?.isHidden = !isSelected
        }
    }
    
    let isDisabled: Bool = false
    
    func setupDisplay(_ value: String?) {
        guard let nameImage = value else {
            return
        }
        
        let i = UIImage(systemName: nameImage)
        let i1 = i?.color(color: .systemGreen)?.withRenderingMode(.alwaysOriginal)
        let i2 = i?.color(color: #colorLiteral(red: 0.3882352941, green: 0.4470588235, blue: 0.5019607843, alpha: 1))?.withRenderingMode(.alwaysOriginal)
        
        imageView?.image = i2
        imageView?.highlightedImage = i1
    }
}

// MARK: Class's public methods
extension TinderItemInfoView {
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        visualize()
    }
}

// MARK: Class's private methods
private extension TinderItemInfoView {
    private func initialize() {
        // todo: Initialize view's here.
    }
    private func visualize() {
        // todo: Visualize view's here.
    }
}
