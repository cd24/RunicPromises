//
//  FunctorTests.swift
//  RunicPromises
//
//  Created by John McAvey on 6/12/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Runes
import PromiseKit
import RunicPromises
import Quick
import Nimble

class Tests: QuickSpec {
    override func spec() {
        describe("Functor") {
            it("Can extract numerics") {
                let intPromise: Promise<Int> = Promise(value: 10)
                let int32Promise: Promise<Int32> = Promise(value: 10)
                let int64Promise: Promise<Int64> = Promise(value: 10)
                let doublePromise: Promise<Double> = Promise(value: 10)
                let floatPromise: Promise<Float> = Promise(value: 10)
                
                ({ $0 + 1 } <^> intPromise).hasValue(11)
                ({ $0 + 1 } <^> int32Promise).hasValue(11)
                ({ $0 + 1 } <^> int64Promise).hasValue(11)
                ({ $0 + 1 } <^> doublePromise).hasValue(11.0)
                ({ $0 + 1 } <^> floatPromise).hasValue(11.0)
            }
            
            it("Can mutate strings") {
                let short = Promise(value: "Hello")
                let complete = { $0.appending(" world!") } <^> short
                complete.hasValue("Hello world!")
            }
            
            it("Can handle custom structs") {
                let test = TestObject(item: "Hello", value: -10)
                let tprom = Promise(value: test)
                let updated = { TestObject(item: $0.item, value: -$0.value) } <^> tprom
                updated.hasValue(TestObject(item: "Hello", value: 10))
            }
        }
        
        // TODO: Applicative
        
        // TODO: Alternative
        
        describe("Monad") {
            it("can forward values") {
                let doublePromise: Promise<Double> = Promise(value: 10) >>- maybeAddOne
                doublePromise.hasValue(11)
                
                let stringPromise = Promise(value: "Hello ") >>- addWorld
                stringPromise.hasValue("Hello world!")
            }
            
            it("can have different in-out") {
                let decoded = Promise(value: "100") >>- fromString
                decoded.hasValue(100)
                let decoded2 = fromString -<< Promise(value: "100")
                decoded2.hasValue(100)
            }
            
            it("can compose functions") {
                (fromString >-> maybeAddOne)("100").hasValue(101)
                (maybeAddOne <-< fromString)("100").hasValue(101)
            }
            
            it("can skip successful values") {
                (fromString("100") >> maybeAddOne(10)).hasValue(11)
                (maybeAddOne(10) << fromString("100")).hasValue(11)
            }
            
            it("can stop at errors") {
                (errors() >> maybeAddOne(1)).hasError(TestError.testErr)
                (maybeAddOne(1) << errors()).hasError(TestError.testErr)
            }
        }
    }
}

public enum TestError: Error {
    case testErr
}

struct TestObject: Equatable {
    let item: String
    let value: Double
    
    public static func ==(lhs: TestObject, rhs: TestObject) -> Bool {
        return lhs.item == rhs.item && lhs.value == rhs.value
    }
}

func errors() -> Promise<Bool> {
    return Promise(error: TestError.testErr)
}

func maybeAddOne(_ value: Double) -> Promise<Double> {
    return Promise(value: value + 1)
}

func addWorld(_ value: String) -> Promise<String> {
    return Promise(value: value.appending(" world!"))
}

func fromString(_ value: String) -> Promise<Double> {
    return Promise { fulfill, reject in
        if let value = Double(value) {
            fulfill(value)
        } else {
            reject(TestError.testErr)
        }
    }
}

extension Promise where T: Equatable {
    func hasValue(_ expected: T) {
        waitUntil { completion in
            self.then { actual -> Void in
                expect(expected) == actual
                completion()
            }
            .catch { error in
                print("Unexpected error: \(error)")
                expect(1) == 2
                completion()
            }
        }
    }
    
    func hasError<Q: Error>(_ expected: Q? = nil) {
        waitUntil { complete in
            self.then { actual -> Void in
                expect(1) == 2
                complete()
            }
            .catch { err in
                if let provided = expected {
                    expect(err).to(matchError(provided))
                }
                complete()
            }
        }
    }
}
