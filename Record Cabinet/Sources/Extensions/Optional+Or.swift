//
//  Optional+Or.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 10.04.22.
//

import Foundation

extension Optional {
    public func or(other: Wrapped) -> Wrapped {
        if let ret = self {
            return ret
        } else {
            return other
        }
    }
}
