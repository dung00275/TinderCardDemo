//
//  Utils.swift
//  TinderCardDemo
//
//  Created by Dung Vu on 10/30/20.
//

import UIKit

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


