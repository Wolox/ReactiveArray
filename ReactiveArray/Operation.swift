//
//  Operation.swift
//  ReactiveArray
//
//  Created by Guido Marucci Blas on 7/1/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

import Foundation

public enum Operation<T>: CustomDebugStringConvertible {
    
    case Append(value: T)
    case Insert(value: T, atIndex: Int)
    case RemoveElement(atIndex: Int)
    
    public func map<U>(mapper: T -> U) -> Operation<U> {
        let result: Operation<U>
        switch self {
        case .Append(let value):
            result = Operation<U>.Append(value: mapper(value))
        case .Insert(let value, let index):
            result = Operation<U>.Insert(value: mapper(value), atIndex: index)
        case .RemoveElement(let index):
            result = Operation<U>.RemoveElement(atIndex: index)
        }
        return result
    }
    
    public var debugDescription: String {
        let description: String
        switch self {
        case .Append(let value):
            description = ".Append(value:\(value))"
        case .Insert(let value, let index):
            description = ".Insert(value: \(value), atIndex:\(index))"
        case .RemoveElement(let index):
            description = ".RemoveElement(atIndex:\(index))"
        }
        return description
    }
    
    public var value: T? {
        switch self {
        case .Append(let value):
            return value
        case .Insert(let value, _):
            return value
        default:
            return Optional.None
        }
    }
    
}

public func ==<T: Equatable>(lhs: Operation<T>, rhs: Operation<T>) -> Bool {
    switch (lhs, rhs) {
    case (.Append(let leftValue), .Append(let rightValue)):
        return leftValue == rightValue
    case (.Insert(let leftValue, let leftIndex), .Insert(let rightValue, let rightIndex)):
        return leftIndex == rightIndex && leftValue == rightValue
    case (.RemoveElement(let leftIndex), .RemoveElement(let rightIndex)):
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