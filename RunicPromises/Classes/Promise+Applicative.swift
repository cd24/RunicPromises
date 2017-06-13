//
//  Promise+Applicative.swift
//  RunicPromises
//
//  Created by John McAvey on 6/12/17.
//

import Foundation
import Runes
import PromiseKit

public func <*> <T, Q>(_ a: Promise<T>, _ f: Promise<(T)->Q>) -> Promise<Q> {
    return a.apply( f )
}

public func <* <T>(_ keep: Promise<T>, _ discard: AnyPromise) -> Promise<T> {
    return keep.sequence( discard )
}

public func *> <T>(_ discard: AnyPromise, _ keep: Promise<T>) -> Promise<T> {
    return keep <* discard
}

public func pure<T>(_ value: T) -> Promise<T> {
    return Promise(value: value)
}

extension Promise {
    public func apply<Q>(_ f: Promise<(T)->Q>) -> Promise<Q> {
        return f.then { (fn: @escaping (T)->Q) -> Promise<Q> in
            return self.then { value -> Promise<Q> in
                return Promise<Q>(value: fn(value))
            }
        }
    }

    public func sequence(_ next: AnyPromise) -> Promise<T> {
        return self.then { value in
            next.then { _ in
                return Promise(value: value)
            }
        }
    }
}
