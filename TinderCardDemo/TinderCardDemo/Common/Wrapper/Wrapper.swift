//  File name   : Wrapper.swift
//
//  Author      : Dung Vu
//  Created date: 11/1/20
//  Version     : 1.00
//  --------------------------------------------------------------
//  
//  --------------------------------------------------------------

import RxSwift
import RxCocoa

// MARK: - Replay
@propertyWrapper
struct Replay<T> {
    private let _event: ReplaySubject<T>
    private let queue: ImmediateSchedulerType
    init(bufferSize: Int, queue: ImmediateSchedulerType) {
        self.queue = queue
        _event = ReplaySubject<T>.create(bufferSize: bufferSize)
    }
    
    init(queue: ImmediateSchedulerType) {
        self.queue = queue
       _event = ReplaySubject<T>.create(bufferSize: 1)
    }
    
    var wrappedValue: T {
        get {
            fatalError("Do not get value from this!!!!")
        }
        
        set {
            _event.onNext(newValue)
        }
    }
    
    var projectedValue: Observable<T> {
        return _event.observeOn(queue)
    }
}

// MARK: - BehaviorReplay
@propertyWrapper
struct VariableReplay<T> {
    private let replay: BehaviorRelay<T>
    
    init(wrappedValue: T) {
        replay = BehaviorRelay(value: wrappedValue)
    }
    
    var wrappedValue: T {
        get {
            return replay.value
        }
        
        set {
            replay.accept(newValue)
        }
    }
    
    var projectedValue: BehaviorRelay<T> {
        return replay
    }
}

// MARK: - Published
@propertyWrapper
struct Published<T> {
    private let subject: PublishSubject<T> = PublishSubject()
    var wrappedValue: T {
        get {
            fatalError("Do not get value from this!!!!")
        }
        
        set {
            subject.onNext(newValue)
        }
    }
    
    var projectedValue: PublishSubject<T> {
        return subject
    }
}


