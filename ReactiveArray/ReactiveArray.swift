//
//  ReactiveArray.swift
//  ReactiveArray
//
//  Created by Guido Marucci Blas on 6/29/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

import Foundation

//
//  ReactiveArray.swift
//  WLXViewModel
//
//  Created by Guido Marucci Blas on 6/15/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class ReactiveArray<T>: CollectionType, MutableCollectionType, CustomDebugStringConvertible {
    
    public typealias OperationProducer = SignalProducer<Operation<T>, NoError>
    public typealias OperationSignal = Signal<Operation<T>, NoError>
    
    private var _elements: Array<T> = []
    
    private let (_signal, _sink) = OperationSignal.pipe()
    public var signal: OperationSignal {
        return _signal
    }
    
    public var producer: OperationProducer {
        let appendCurrentElements = OperationProducer(values:_elements.map { Operation.Append(value: $0) })
        let forwardOperations = OperationProducer { (observer, dispoable) in self._signal.observe(observer) }
        
        return  appendCurrentElements.concat(forwardOperations)
    }
    
    private let _mutableCount: MutableProperty<Int>
    public let observableCount:PropertyOf<Int>
    
    public var isEmpty: Bool {
        return _elements.isEmpty
    }
    
    public var count: Int {
        return _elements.count
    }
    
    public var startIndex: Int {
        return _elements.startIndex
    }
    
    public var endIndex: Int {
        return _elements.endIndex
    }
    
    public var first: T? {
        return _elements.first
    }
    
    public var last: T? {
        let value: T?
        if _elements.count > 0 {
            value = _elements[_elements.count - 1]
        } else {
            value = Optional.None
        }
        return value
    }
    
    public var debugDescription: String {
        return _elements.debugDescription
    }
    
    public init(elements:[T]) {
        _elements = elements
        _mutableCount = MutableProperty(elements.count)
        observableCount = PropertyOf(_mutableCount)
        
        _signal.observe { [unowned self](event) in
            if case .Next(let operation) = event {
                self.updateArray(operation)
            }
        }

    }
    
    public convenience init(producer: OperationProducer) {
        self.init()
        
        producer.start(_sink)
    }
    
    public convenience init() {
        self.init(elements: [])
    }
    
    public subscript(index: Int) -> T {
        get {
            return _elements[index]
        }
        set(newValue) {
            update(newValue, atIndex: index)
        }
    }
    
    public func append(element: T) {
        let operation: Operation<T> = .Append(value: element)
        _sink(Event.Next(operation))
    }
    
    public func insert(newElement: T, atIndex index : Int) {
        let operation: Operation<T> = .Insert(value: newElement, atIndex: index)
        _sink(Event.Next(operation))
    }
    
    public func update(element: T, atIndex index: Int) {
        let operation: Operation<T> = .Update(value: element, atIndex: index)
        _sink(Event.Next(operation))
    }
    
    public func removeAtIndex(index:Int) {
        let operation: Operation<T> = .RemoveElement(atIndex: index)
        _sink(Event.Next(operation))
    }
    
    public func mirror<U>(transformer: T -> U) -> ReactiveArray<U> {
        return ReactiveArray<U>(producer: producer.map { $0.map(transformer) })
    }
    
    public func toArray() -> Array<T> {
        return _elements
    }
    
    private func updateArray(operation: Operation<T>) {
        switch operation {
        case .Append(let value):
            _elements.append(value)
            _mutableCount.value = _elements.count
        case .Insert(let value, let index):
            _elements.insert(value, atIndex: index)
        case .Update(let value, let index):
            _elements[index] = value
        case .RemoveElement(let index):
            _elements.removeAtIndex(index)
            _mutableCount.value = _elements.count
        }
    }
    
}
