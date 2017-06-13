//
//  Promise+Functor.swift
//  RunicPromises
//
//  Created by John McAvey on 6/12/17.
//

import Foundation
import PromiseKit
import Runes

/**
An implementation of `fmap` for promises. If the inner value of the promise is an error then the promise is unchanged. Otherwise, the value is unwrapped and passed to the provided function.
Example:
```
func addOne(_ value: Double) -> Double {
    return value + 1
}

let myPromise = Promise<Double>(value: 10)
let emptyPromise = Promise<Double>(error: ...)
print( addOne <^> myPromise ) // Prints '11'
print( addOne <^> emptyPromise ) // Prints error description
```
- Parameters:
    - function: A function transforming the inner value of the provided promise.
    - wrapper: A promise to unwrap and transform.
- Returns: A promise with either the transformed value or the error.
*/
public func <^> <T, U>( _ function: @escaping (T) -> U, _ wrapper: Promise<T>) -> Promise<U> {
    return wrapper.fmap( function )
}

extension Promise where T: Any {
    /**
    An implementation of `fmap` for promises. If the inner value of the promise is an error then the promise is unchanged. Otherwise, the value is unwrapped and passed to the provided function.
    Example:
    ```
    func addOne(_ value: Double) -> Double {
        return value + 1
    }

    let myPromise = Promise<Double>(value: 10)
    let emptyPromise = Promise<Double>(error: ...)
    print( myPromise.fmap(addOne) ) // Prints '11'
    print( emptyPromise.fmap(addOne) ) // Prints error description
    ```
    - Parameters:
        - function: A function transforming the inner value of the recieving promise.
    - Returns: A promise with either the transformed value or the error.
    */
    public func fmap<U>(_ function: @escaping (T)->U) -> Promise<U> {
        return self.then { value in
            return Promise<U>(value: function(value) )
        }
    }
}
