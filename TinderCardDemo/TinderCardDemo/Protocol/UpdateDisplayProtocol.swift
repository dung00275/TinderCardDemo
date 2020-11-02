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
