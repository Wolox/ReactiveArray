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
import Box

class OperationSpec: QuickSpec {

    override func spec() {
        
        var operation: Operation<Int>!
        
        describe("map") {
            
            context("when the operation is an Append operation") {
                
                beforeEach {
                    operation = Operation.Append(value: Box(10))
                }
                
                it("maps the value to be appended") {
                    let mappedOperation = operation.map { $0 * 2 }
                    
                    let areEqual = mappedOperation == Operation.Append(value: Box(20))
                    expect(areEqual).to(beTrue())
                }
                
            }
            
            context("when the operation is an Insert operation") {
                
                beforeEach {
                    operation = Operation.Insert(index: 5, value: Box(10))
                }
                
                it("maps the value to be inserted") {
                    let mappedOperation = operation.map { $0 * 2 }
                    
                    let areEqual = mappedOperation == Operation.Insert(index: 5, value: Box(20))
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
        
    }
    
}