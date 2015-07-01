//
//  Operation.swift
//  ReactiveArray
//
//  Created by Guido Marucci Blas on 7/1/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

import Foundation
import Box

public enum Operation<T>: DebugPrintable {
    
    case Append(value: Box<T>)
    case Insert(index: Int, value: Box<T>)
    case Delete(index: Int)
    
    public func map<U>(mapper: T -> U) -> Operation<U> {
        let result: Operation<U>
        switch self {
        case .Append(let boxedValue):
            result = Operation<U>.Append(value: Box(mapper(boxedValue.value)))
        case .Insert(let index, let boxedValue):
            result = Operation<U>.Insert(index: index, value: Box(mapper(boxedValue.value)))
        case .Delete(let index):
            result = Operation<U>.Delete(index: index)
        }
        return result
    }
    
    public var debugDescription: String {
        let description: String
        switch self {
        case .Append(let boxedValue):
            description = ".Append(\(boxedValue.value))"
        case .Insert(let index, let boxedValue):
            description = ".Insert(\(index), \(boxedValue.value))"
        case .Delete(let index):
            description = ".Delete(\(index))"
        }
        return description
    }
}

// TODO: Uses constrained protocol extension when moving to Swift 2.0
// extension Operation: Equatable where T: Equatable {}

public func ==<T: Equatable>(lhs: Operation<T>, rhs: Operation<T>) -> Bool {
    switch (lhs, rhs) {
    case (.Append(let leftBoxedValue), .Append(let rightBoxedValue)):
        return leftBoxedValue.value == rightBoxedValue.value
    case (.Insert(let leftIndex, let leftBoxedValue), .Insert(let rightIndex, let rightBoxedValue)):
        return leftIndex == rightIndex && leftBoxedValue.value == rightBoxedValue.value
    case (.Delete(let leftIndex), .Delete(let rightIndex)):
        return leftIndex == rightIndex
    default:
        return false
    }
}

// WTF!!! Again this is needed because the compiler is super stupid!
public func !=<T: Equatable>(lhs: Operation<T>, rhs: Operation<T>) -> Bool {
    return !(lhs == rhs)
}

// This is needed because somehow the compiler does not realize
// that when T is equatable it can compare an array of operations.
public func ==<T: Equatable>(lhs: [Operation<T>], rhs: [Operation<T>]) -> Bool {
    let areEqual: () -> Bool = {
        for var i = 0; i < lhs.count; i++ {
            if lhs[i] != rhs[i] {
                return false
            }
        }
        return true
    }
    return lhs.count == rhs.count && areEqual()
}