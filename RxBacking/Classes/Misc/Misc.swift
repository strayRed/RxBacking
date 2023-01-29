//
//  Misc.swift
//  RxBacking
//
//  Created by strayRed on 2023/1/24.
//

import Foundation

func abstractMethod() -> Never {
    fatalError("This is a abstract method")
}

func castOrFatalError<T>(_ value: Any!) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        fatalError("Failure converting from \(String(describing: value)) to \(T.self)")
    }
    return result
}
