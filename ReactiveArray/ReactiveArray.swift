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
import Box

public final class ReactiveArray<T>: CollectionType, MutableCollectionType, DebugPrintable {
    
    typealias OperationProducer = SignalProducer<Operation<T>, NoError>
    typealias OperationSignal = Signal<Operation<T>, NoError>
    
    private var _elements: Array<T> = []
    
    private let (_signal, _sink) = OperationSignal.pipe()
    public var signal: OperationSignal {
        return _signal
    }
    
    public var producer: OperationProducer {
        let appendCurrentElements = OperationProducer { [unowned self](observer, disposable) in
            for element in self._elements {
                let operation = Operation.Append(value: Box(element))
                observer.put(Event.Next(Box(operation)))
            }
            observer.put(Event.Completed)
        }
        
        let forwardOperations = OperationProducer { (observer, dispoable) in self._signal.observe(observer) }
        
        return  appendCurrentElements |> concat(forwardOperations)
    }
    
    private let _mutableCount = MutableProperty<Int>(0)
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
    
    public var debugDescription: String {
        return _elements.debugDescription
    }
    
    // TODO: Remove this in Swift 2.0
    public func generate() -> IndexingGenerator<Array<T>> {
        return _elements.generate()
    }
    
    init(elements:[T]) {
        _elements = elements
        observableCount = PropertyOf(_mutableCount)
        
        _signal.observe { [unowned self](operation) in
            self.updateArray(operation)
        }
        
    }
    
    convenience init(producer: OperationProducer) {
        self.init()
        
        producer |> start(_sink)
    }
    
    convenience init() {
        self.init(elements: [])
    }
    
    public subscript(index: Int) -> T {
        get {
            return _elements[index]
        }
        set(newValue) {
            insert(newValue, atIndex: index)
        }
    }
    
    public func append(element: T) {
        let operation: Operation<T> = .Append(value: Box(element))
        _sink.put(Event.Next(Box(operation)))
    }
    
    public func insert(newElement: T, atIndex: Int) {
        let operation: Operation<T> = .Insert(index: atIndex, value: Box(newElement))
        _sink.put(Event.Next(Box(operation)))
    }
    
    public func removeAtIndex(index:Int) {
        let operation: Operation<T> = .Delete(index: index)
        _sink.put(Event.Next(Box(operation)))
    }
    
    public func mirror<U>(transformer: T -> U) -> ReactiveArray<U> {
        return ReactiveArray<U>(producer: producer |> ReactiveCocoa.map { $0.map(transformer) })
    }
    
    private func updateArray(operation: Operation<T>) {
        switch operation {
        case .Append(let boxedValue):
            _elements.append(boxedValue.value)
        case .Insert(let index, let boxedValue):
            _elements[index] = boxedValue.value
        case .Delete(let index):
            _elements.removeAtIndex(index)
        }
        _mutableCount.put(_elements.count)
    }
    
}
