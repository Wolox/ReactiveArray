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
    case Update(value: T, atIndex: Int)
    case RemoveElement(atIndex: Int, oldValue : T)
    
    public func map<U>(mapper: T -> U) -> Operation<U> {
        let result: Operation<U>
        switch self {
        case .Append(let value):
            result = Operation<U>.Append(value: mapper(value))
        case .Insert(let value, let index):
            result = Operation<U>.Insert(value: mapper(value), atIndex: index)
        case .Update(let value, let index):
            result = Operation<U>.Update(value: mapper(value), atIndex: index)
        case .RemoveElement(let index, let oldValue):
            result = Operation<U>.RemoveElement(atIndex: index, oldValue: mapper(oldValue))
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
        case .Update(let value, let index):
            description = ".Update(value: \(value), atIndex:\(index))"
        case .RemoveElement(let index, let oldValue):
            description = ".RemoveElement(atIndex:\(index), oldValue:\(oldValue))"
        }
        return description
    }
    
    public var value: T? {
        switch self {
        case .Append(let value):
            return value
        case .Insert(let value, _):
            return value
        case .Update(let value, _):
            return value
        case .RemoveElement(_, let oldValue):
            return oldValue
        }
    }
    
}

public func ==<T: Equatable>(lhs: Operation<T>, rhs: Operation<T>) -> Bool {
    switch (lhs, rhs) {
    case (.Append(let leftValue), .Append(let rightValue)):
        return leftValue == rightValue
    case (.Insert(let leftValue, let leftIndex), .Insert(let rightValue, let rightIndex)):
        return leftIndex == rightIndex && leftValue == rightValue
    case (.Update(let leftValue, let leftIndex), .Update(let rightValue, let rightIndex)):
        return leftIndex == rightIndex && leftValue == rightValue
    case (.RemoveElement(let leftIndex, let leftValue), .RemoveElement(let rightIndex, let rightValue)):
        return leftIndex == rightIndex && leftValue == rightValue
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