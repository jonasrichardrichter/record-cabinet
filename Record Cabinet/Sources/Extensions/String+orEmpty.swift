//
//  String+orEmpty.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 10.04.22.
//

import Foundation

extension Optional where Wrapped == String {
    func orEmpty() -> String {
        return self.or(other: "")
    }
}
