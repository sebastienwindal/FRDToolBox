//
//  Result.swift
//  FRDToolBox
//
//  Created by Sebastien Windal on 5/31/17.
//  Copyright © 2017 Sebastien Windal. All rights reserved.
//

import Foundation

public enum Result<T> {
    case Success(T)
    case Failure(Error)
}

public extension Result {
    public func map<U>(f: (T)->U) -> Result<U> {
        switch self {
        case .Success(let t): return .Success(f(t))
        case .Failure(let err): return .Failure(err)
        }
    }
    public func flatMap<U>(f: (T)->Result<U>) -> Result<U> {
        switch self {
        case .Success(let t): return f(t)
        case .Failure(let err): return .Failure(err)
        }
    }
}


public extension Result {
    // Return the value if it's a .Success or throw the error if it's a .Failure
    public func resolve() throws -> T {
        switch self {
        case Result.Success(let value): return value
        case Result.Failure(let error): throw error
        }
    }
    
    // Construct a .Success if the expression returns a value or a .Failure if it throws
    public init(_ throwingExpr: (Void) throws -> T) {
        do {
            let value = try throwingExpr()
            self = Result.Success(value)
        } catch {
            self = Result.Failure(error)
        }
    }
}
