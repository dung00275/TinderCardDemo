//
//  Utils.swift
//  TinderCardDemo
//
//  Created by Dung Vu on 10/30/20.
//

import UIKit
import Kingfisher
import RxSwift

// MARK: -- Operator
infix operator >>>: Display
precedencegroup Display {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: AdditionPrecedence
}

@discardableResult
func >>> <E: AnyObject>(lhs: E, block: (E) -> Void) -> E {
    block(lhs)
    return lhs
}

@discardableResult
func >>> <E: AnyObject>(lhs: E?, block: (E?) -> Void) -> E? {
    block(lhs)
    return lhs
}

@discardableResult
func >>> <E, F>(lhs: E, rhs: F) -> E where E: UIView, F: UIView {
    rhs.addSubview(lhs)
    return lhs
}

@discardableResult
func >>> <E, F>(lhs: E, rhs: F?) -> E where E: UIView, F: UIView {
    rhs?.addSubview(lhs)
    return lhs
}

// MARK: -- Direction
struct CardDirection: OptionSet {
    var rawValue: Int
    static let none: CardDirection = CardDirection(rawValue: 0x0000)
    static let left: CardDirection = CardDirection(rawValue: 0x0001)
    static let right: CardDirection = CardDirection(rawValue: 0x0010)
    static let up: CardDirection = CardDirection(rawValue: 0x0100)
    static let down: CardDirection = CardDirection(rawValue: 0x1000)
    static let horizontal: CardDirection = [.left, .right]
    static let vertical: CardDirection = [.up, .down]
    static let all: CardDirection = [.left, .right, .up, .down]
    
    static func from(point: CGPoint) -> CardDirection {
        switch (point.x, point.y) {
        case let (x, y) where abs(x) >= abs(y) && x > 0:
            return .right
        case let (x, y) where abs(x) >= abs(y) && x < 0:
            return .left
        case let (x, y) where abs(x) < abs(y) && y < 0:
            return .up
        case let (x, y) where abs(x) < abs(y) && y > 0:
            return .down
        default:
            return .none
        }
    }
}

extension CGPoint {

    init(vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
    }

    var normalized: CGPoint {
        return CGPoint(x: x / magnitude, y: y / magnitude)
    }

    var magnitude: CGFloat {
        return CGFloat(sqrtf(powf(Float(x), 2) + powf(Float(y), 2)))
    }

    static func sameDirection(_ p1: CGPoint, p2: CGPoint) -> Bool {

        let calculate: (CGFloat) -> Int = {
            ($0 < 0.0) ? -1 : ($0 > 0.0) ? +1 : 0
        }
        return calculate(p1.x) == calculate(p2.x) && calculate(p1.y) == calculate(p2.y)
    }
    
    static func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }
}

extension Array {
    subscript(safe idx: Int) -> Element? {
        guard 0..<self.count ~= idx else {
            return nil
        }
        return self[idx]
    }
}

// MARK: - weakitify code
protocol Weakifiable: AnyObject {}
extension Weakifiable {
    func weakify(_ code: @escaping (Self) -> Void) -> () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            code(self)
        }
    }
    
    func weakify<T>(_ code: @escaping (T, Self) -> Void) -> (T) -> Void {
        return { [weak self] arg in
            guard let self = self else { return }
            code(arg, self)
        }
    }
}

// MARK: - Controller
extension UIViewController: Weakifiable {}

// MARK: - UIView
@IBDesignable
extension UIView {
    @IBInspectable
    public var cornerRadius: CGFloat {
        set(radius) {
            self.layer.cornerRadius = radius
            self.layer.masksToBounds = radius > 0
        }

        get {
            return self.layer.cornerRadius
        }
    }

    @IBInspectable
    public var borderWidth: CGFloat {
        set(borderWidth) {
            self.layer.borderWidth = borderWidth
        }

        get {
            return self.layer.borderWidth
        }
    }

    @IBInspectable
    public var borderColor: UIColor? {
        set(color) {
            self.layer.borderColor = color?.cgColor
        }

        get {
            if let color = self.layer.borderColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }

    func dropShadow() {
        shadowColor = .black
        shadowOpacity = 0.1
        shadowRadius = 20.0
        shadowOffset = CGSize(width: 0.0, height: 4.0)
    }
}

// MARK: - Image Display
protocol ImageDisplayProtocol {
    var imageURL: String? { get }
    var sourceImage: Source? { get }
}
extension ImageDisplayProtocol {
    var sourceImage: Source? {
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            return nil
        }
        
        return .network(url)
    }
}

struct ImageProcessorDisplay: ImageProcessor {
    var identifier: String
    var size: CGSize
    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        var img: KFCrossPlatformImage?
        switch item {
        case let .data(data):
            let scale: CGFloat = UIScreen.main.scale
            img = KingfisherWrapper.downsampledImage(data: data, to: size, scale: scale)
        case let .image(image):
            img = image
        }
        return img
    }
}
// MARK: -- Image View
extension UIImageView {
    @discardableResult
    func setImage(from source: ImageDisplayProtocol?, placeholder: UIImage? = nil, size: CGSize? = nil) -> DownloadTask? {
        let placeholder = placeholder //?? UIImageView.imageDefault
        guard let s = source else {
            return nil
        }
        let mSize = size ?? bounds.size
        precondition(mSize != .zero, "Recheck size")
        let key = source?.sourceImage?.url?.lastPathComponent ?? "com.vato.image_\(mSize)"
        let processor = ImageProcessorDisplay(identifier: key, size: mSize)
        
        if case .activity = kf.indicatorType  {
        } else {
            kf.indicatorType = .activity
        }
        let options: KingfisherOptionsInfo = [.memoryCacheExpiration(.never), .diskCacheExpiration(.never) , .processor(processor), .callbackQueue(CallbackQueue.dispatch(.global(qos: .background)))]
        let task = kf.setImage(with: s.sourceImage, placeholder: placeholder, options: options)
        return task
    }
}

extension UIImage {
    func color(color: UIColor) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
                color.setFill()

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: cgImage)
        context?.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
        
//        guard let maskImage = cgImage else {
//            return nil
//        }
//        let width = size.width
//        let height = size.height
//        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
//
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
//        guard let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
//            return nil
//        }
//
//        context.clip(to: bounds, mask: maskImage)
//        context.setFillColor(color.cgColor)
//        context.fill(bounds)
//
//        if let cgImage = context.makeImage() {
//            let coloredImage = UIImage(cgImage: cgImage)
//            return coloredImage
//        } else {
//            return nil
//        }
    }
}

// MARK: -- Load xib
protocol LoadXibProtocol {}
extension LoadXibProtocol where Self: UIView {
    static func loadXib() -> Self {
        let bundle = Bundle(for: self)
        let name = "\(self)"
        guard let view = UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("error xib \(name)")
        }
        return view
    }
}
extension UIView: LoadXibProtocol {}

// MARK: -- Observable
protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? {
        return self
    }
}

extension Observable where Element: OptionalType {
    func filterNil() -> Observable<Element.Wrapped> {
        return self.flatMap { element -> Observable<Element.Wrapped> in
            switch element.value {
            case .some(let v):
                return .just(v)
            default:
                return .empty()
            }
        }
    }
}

