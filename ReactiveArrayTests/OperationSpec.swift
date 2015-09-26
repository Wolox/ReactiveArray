//
//  OperationSpec.swift
//  ReactiveArray
//
//  Created by Guido Marucci Blas on 7/2/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

import Quick
import Nimble
import ReactiveArray
import ReactiveCocoa

class OperationSpec: QuickSpec {

    override func spec() {
        
        var operation: Operation<Int>!
        
        describe("#map") {
            
            context("when the operation is an Append operation") {
                
                beforeEach {
                    operation = Operation.Append(value: 10)
                }
                
                it("maps the value to be appended") {
                    let mappedOperation = operation.map { $0 * 2 }
                    
                    let areEqual = mappedOperation == Operation.Append(value: 20)
                    expect(areEqual).to(beTrue())
                }
                
            }
            
            context("when the operation is an Insert operation") {
                
                beforeEach {
                    operation = Operation.Insert(value: 10, atIndex: 5)
                }
                
                it("maps the value to be inserted") {
                    let mappedOperation = operation.map { $0 * 2 }
                    
                    let areEqual = mappedOperation == Operation.Insert(value: 20, atIndex: 5)
                    expect(areEqual).to(beTrue())
                }
                
            }
            
            context("when the operation is a Delete operation") {
                
                beforeEach {
                    operation = Operation.RemoveElement(atIndex: 5)
                }
                
                it("does nothing") {
                    let mappedOperation = operation.map { $0 * 2 }
                    
                    let areEqual = mappedOperation == operation
                    expect(areEqual).to(beTrue())
                }
                
            }
            
        }
        
        describe("#value") {
        
            context("when the operation is an Append operation") {
                
                beforeEach {
                    operation = Operation.Append(value: 10)
                }
                
                it("returns the appended value") {
                    expect(operation.value).to(equal(10))
                }
                
            }
            
            context("when the operation is an Insert operation") {
                
                beforeEach {
                    operation = Operation.Insert(value: 10, atIndex: 5)
                }
                
                it("returns the inserted value") {
                    expect(operation.value).to(equal(10))
                }
                
            }
            
            context("when the operation is an Remove operation") {
                
                beforeEach {
                    operation = Operation.RemoveElement(atIndex: 5)
                }
                
                it("returns .None") {
                    expect(operation.value).to(beNil())
                }
                
            }
            
        }
        
    }
    
}