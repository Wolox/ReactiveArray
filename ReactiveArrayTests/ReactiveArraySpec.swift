//
//  ReactiveArraySpec.swift
//  ReactiveArraySpec
//
//  Created by Guido Marucci Blas on 6/29/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

import Quick
import Nimble
import ReactiveArray
import ReactiveCocoa

private func waitForOperation<T>(fromProducer producer: SignalProducer<Operation<T>, NoError>,
    when: () -> (),
    onAppend: T -> () = { fail("Invalid operation type: .Append(\($0))") },
    onInsert: (T, Int) -> () = { fail("Invalid operation type: .Insert(\($0), \($1))") },
    onDelete: Int -> () = { fail("Invalid operation type: .Delete(\($0))") }) {
        
        waitUntil { done in
            producer.start(next: { operation in
                switch operation {
                case .Append(let value):
                    onAppend(value)
                case .Insert(let value, let index):
                    onInsert(value, index)
                case .RemoveElement(let index):
                    onDelete(index)
                }
                done()
            })
            when()
        }
        
}

private func waitForOperation<T>(fromSignal signal: Signal<Operation<T>, NoError>,
    when: () -> (),
    onAppend: T -> () = { fail("Invalid operation type: .Append(\($0))") },
    onInsert: (T, Int) -> () = { fail("Invalid operation type: .Insert(\($0), \($1))") },
    onDelete: Int -> () = { fail("Invalid operation type: .Delete(\($0))") }) {
        
    let producer = SignalProducer<Operation<T>, NoError> { (observer, disposable) in signal.observe(observer) }
    waitForOperation(fromProducer: producer, when: when, onAppend: onAppend, onInsert: onInsert, onDelete: onDelete)
}

private func waitForOperation<T>(fromArray array: ReactiveArray<T>,
    when: () -> (),
    onAppend: T -> () = { fail("Invalid operation type: .Append(\($0))") },
    onInsert: (T, Int) -> () = { fail("Invalid operation type: .Insert(\($0), \($1))") },
    onDelete: Int -> () = { fail("Invalid operation type: .Delete(\($0))") }) {
        
    waitForOperation(fromSignal: array.signal, when: when, onAppend: onAppend, onInsert: onInsert, onDelete: onDelete)
}

class ReactiveArraySpec: QuickSpec {
    
    override func spec() {
        
        var array: ReactiveArray<Int>!
        
        beforeEach {
            array = ReactiveArray(elements: [1,2,3,4])
        }
        
        describe("#append") {
            
            it("inserts the given element at the end of the array") {
                array.append(5)
                
                expect(array[array.count - 1]).to(equal(5))
            }
            
            it("increments the amount of elements in the array by one") {
                let countBeforeAppend = array.count
                
                array.append(5)
                
                expect(array.count).to(equal(countBeforeAppend + 1))
            }
            
            it("signals an append operation") {
                waitForOperation(
                    fromArray: array,
                    when: {
                        array.append(5)
                    },
                    onAppend: { value in
                        expect(value).to(equal(5))
                    }
                )
            }
            
        }
        
        describe("#insert") {
            
            context("when there is a value at the given position") {
                
                it("replaces the old value with the new one") {
                    array.insert(5, atIndex: 1)
                    
                    expect(array[1]).to(equal(5))
                }
                
                it("signals an insert operation") {
                    waitForOperation(
                        fromArray: array,
                        when: {
                            array.insert(5, atIndex: 1)
                        },
                        onInsert: { (value, index) in
                            expect(value).to(equal(5))
                            expect(index).to(equal(1))
                        }
                    )
                }
                
            }
            
            // TODO: Fix this case because this raises an exception that cannot
            // be caught
//            context("when the index is out of bounds") {
//
//                it("raises an exception") {
//                    expect {
//                        array.insert(5, atIndex: array.count + 10)
//                    }.to(raiseException(named: "NSInternalInconsistencyException"))
//                }
//
//            }
            
        }
        
        describe("#removeAtIndex") {
            
            it("removes the element at the given position") {
                array.removeAtIndex(1)
                
                expect(array.toArray()).to(equal([1,3,4]))
            }
            
            it("signals a delete operation") {
                waitForOperation(
                    fromArray: array,
                    when: {
                        array.removeAtIndex(1)
                    },
                    onDelete: { index in
                        expect(index).to(equal(1))
                    }
                )
            }

            
        }
        
        describe("#[]") {
            
            it("returns the element at the given position") {
                expect(array[2]).to(equal(3))
            }
            
        }
        
        describe("#[]=") {
            
            context("when there is a value at the given position") {
                
                it("replaces the old value with the new one") {
                    array[1] = 5
                    
                    expect(array[1]).to(equal(5))
                }
                
                it("signals an insert operation") {
                    waitForOperation(
                        fromArray: array,
                        when: {
                            array[1] = 5
                        },
                        onInsert: { (value, index) in
                            expect(value).to(equal(5))
                            expect(index).to(equal(1))
                        }
                    )
                }
                
            }
            
        }
        
        describe("#mirror") {
            
            var mirror: ReactiveArray<Int>!
            
            beforeEach {
                mirror = array.mirror { $0 + 10 }
            }
            
            it("returns a new reactive array that maps the values of the original array") {
                expect(mirror.toArray()).to(equal([11, 12, 13, 14]))
            }
            
            context("when a insert is executed on the original array") {
                
                it("signals a mapped insert operation") {
                    waitForOperation(
                        fromArray: mirror,
                        when: {
                            array[1] = 5
                        },
                        onInsert: { (value, index) in
                            expect(value).to(equal(15))
                            expect(index).to(equal(1))
                        }
                    )
                }
                
            }
            
            context("when an append is executed on the original array") {
                
                it("signals a mapped append operation") {
                    waitForOperation(
                        fromArray: mirror,
                        when: {
                            array.append(5)
                        },
                        onAppend: { value in
                            expect(value).to(equal(15))
                        }
                    )
                }
                
            }
            
            context("when a delete is executed on the original array") {
                
                it("signals a mapped delete operation") {
                    waitForOperation(
                        fromArray: mirror,
                        when: {
                            array.removeAtIndex(1)
                        },
                        onDelete: { index in
                            expect(index).to(equal(1))
                        }
                    )
                }
                
            }
            
        }
        
        describe("#producer") {
            
            context("when the array has elements") {
                
                it("signals an append operation for each stored element") {
                    waitUntil { done in
                        array.producer
                            .take(array.count)
                            .collect()
                            .start(next: { operations in
                                let expectedOperations: [Operation<Int>] = array.map { Operation.Append(value: $0) }
                                let result = operations == expectedOperations
                                expect(result).to(beTrue())
                                done()
                            })
                    }
                }
                
            }
            
            context("when an append operation is executed in the original array") {
                
                it("forwards the operation") {
                    let a = ReactiveArray<Int>()
                    
                    waitForOperation(
                        fromProducer: a.producer,
                        when: {
                            a.append(5)
                        },
                        onAppend: { value in
                            expect(value).to(equal(5))
                        }
                    )
                }
                
            }
            
            context("when an insert operation is executed in the original array") {
                
                it("forwards the operation") {
                    let a = ReactiveArray<Int>(elements: [1])
                    
                    waitForOperation(
                        fromProducer: a.producer.skip(1), // Skips the operation triggered due to the array not being empty
                        when: {
                            a.insert(5, atIndex: 0)
                        },
                        onInsert: { (value, index) in
                            expect(value).to(equal(5))
                            expect(index).to(equal(0))
                        }
                    )
                }
                
            }
            
            context("when a delete operation is executed in the original array") {
                
                it("forwards the operation") {
                    let a = ReactiveArray<Int>(elements: [1])
                    
                    waitForOperation(
                        fromProducer: a.producer.skip(1), // Skips the operation triggered due to the array not being empty
                        when: {
                            a.removeAtIndex(0)
                        },
                        onDelete: { index in
                            expect(index).to(equal(0))
                        }
                    )
                }
                
            }
            
        }
        
        describe("#signal") {
            
            context("when an insert operation is executed") {
                
                it("signals the operations") {
                    waitForOperation(
                        fromSignal: array.signal,
                        when: {
                            array.insert(5, atIndex: 1)
                        },
                        onInsert: { (value, index) in
                            expect(value).to(equal(5))
                            expect(index).to(equal(1))
                        }
                    )
                }
                
            }
            
            context("when an append operation is executed") {
                
                it("signals the operations") {
                    waitForOperation(
                        fromSignal: array.signal,
                        when: {
                            array.append(5)
                        },
                        onAppend: { value in
                            expect(value).to(equal(5))
                        }
                    )
                }
                
            }
            
            context("when a delete operation is executed") {
                
                it("signals the operations") {
                    waitForOperation(
                        fromSignal: array.signal,
                        when: {
                            array.removeAtIndex(1)
                        },
                        onDelete: { index in
                            expect(index).to(equal(1))
                        }
                    )
                }
                
            }
            
        }
        
        describe("observableCount") {
            
            var countBeforeOperation: Int!
            var producer: SignalProducer<Int, NoError>!
            
            beforeEach {
                countBeforeOperation = array.count
                producer = array.observableCount.producer.skip(1)
            }
            
            it("returns the initial amount of elements in the array") {
                producer.start(next: { count in
                    expect(count).to(equal(countBeforeOperation))
                })
            }
            
            context("when an insert operation is executed") {
                
                beforeEach {
                    producer = producer |> skip(1)
                }
                
                it("does not update the count") {
                    waitUntil { done in
                        producer
                            .take(1)
                            .collect()
                            .start(next: { counts in
                                expect(counts).to(equal([countBeforeOperation + 1]))
                                done()
                            })
                        
                        array.insert(657, atIndex: 1)
                        array.append(656)
                    }
                }
                
            }
            
            
            context("when an append operation is executed") {
                
                beforeEach {
                    producer = producer |> skip(1)
                }
                
                it("updates the count") {
                    waitUntil { done in
                        producer.start(next: { count in
                            expect(count).to(equal(countBeforeOperation + 1))
                            done()
                        })
                        
                        array.append(656)
                    }
                }
                
            }
            
            context("when a delete operation is executed") {
                
                beforeEach {
                    producer = producer |> skip(1)
                }
                
                it("updates the count") {
                    waitUntil { done in
                        producer.start(next: { count in
                            expect(count).to(equal(countBeforeOperation - 1))
                            done()
                        })
                        
                        array.removeAtIndex(1)
                    }
                }
                
            }
            
        }
        
        describe("isEmpty") {
            
            context("when the array is empty") {
                
                it("returns true") {
                    expect(ReactiveArray<Int>().isEmpty).to(beTrue())
                }
                
            }
            
            context("when the array is not empty") {
                
                it("returns false") {
                    expect(array.isEmpty).to(beFalse())
                }
                
            }
            
        }
        
        describe("count") {
            
            it("returns the amount of elements in the array") {
                expect(array.count).to(equal(4))
            }
            
        }
        
        describe("startIndex") {
            
            context("when the array is not empty") {

                it("returns the index of the first element") {
                    expect(array.startIndex).to(equal(0))
                }
                
            }
            
            context("when the array is empty") {
                
                beforeEach {
                    array = ReactiveArray<Int>()
                }
                
                it("returns the index of the first element") {
                    expect(array.startIndex).to(equal(0))
                }
                
            }
            
        }
        
        describe("endIndex") {
            
            context("when the array is not empty") {
                
                it("returns the index of the last element plus one") {
                    expect(array.endIndex).to(equal(array.count))
                }
                
            }
            
            context("when the array is empty") {
                
                beforeEach {
                    array = ReactiveArray<Int>()
                }
                
                it("returns zero") {
                    expect(array.startIndex).to(equal(0))
                }
                
            }
            
        }
        
        describe("first") {
            
            it("returns the first element in the array") {
                expect(array.first).to(equal(1))
            }
            
        }
        
        describe("last") {
            
            it("returns the last element in the array") {
                expect(array.last).to(equal(4))
            }
            
            context("when the array is empty") {
             
                beforeEach {
                    array = ReactiveArray<Int>()
                }
                
                it("returns .None") {
                    expect(array.last).to(beNil())
                }
                
            }
            
        }
        
    }
    
}
