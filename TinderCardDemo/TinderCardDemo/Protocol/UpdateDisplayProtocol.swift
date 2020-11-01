//  File name   : UpdateDisplayProtocol.swift
//
//  Author      : Dung Vu
//  Created date: 10/30/20
//  Version     : 1.00
//  --------------------------------------------------------------
//  
//  --------------------------------------------------------------

import UIKit

protocol UpdateDisplayProtocol {
    associatedtype Value
    func setupDisplay(_ value: Value?)
}

protocol SwipeHandlerDirectionViewProtocol {
    func handlerDirection(location: CGPoint, translation: CGPoint)
    func cancelDragGesture()
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
