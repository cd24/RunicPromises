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

class FunctorTests: QuickSpec {
    override func spec() {
        describe("Functor can extract values") {
            it("Can extract numerics") {
                let intPromise: Promise<Int> = Promise(value: 10)
                let int32Promise: Promise<Int32> = Promise(value: 10)
                let int64Promise: Promise<Int64> = Promise(value: 10)
                let intDoublePromise: Promise<Double> = Promise(value: 10)
                let intFloatPromise: Promise<Float> = Promise(value: 10)
                
                let addOne = { $0 + 1 }
                
                (addOne <^> intPromise).hasValue(11)
            }
        }
    }
}

extension Promise where T: Comparable {
    func hasValue(_ expected: T) {
        self.then { actual -> Void in
            expect(expected) == actual
        }
        .catch { error in
            print("Unexpected error: \(error)")
            expect(1) == 2
        }
    }
    
    func hasError<Q: Error>(_ expected: Q? = nil) {
        self.then { actual -> Void in
            expect(1) == 2
        }
        .catch { err in
            if let provided = expected {
                expect(err).to(matchError(provided))
            }
        }
    }
}
