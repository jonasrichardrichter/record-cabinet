//
//  String+Localized.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 17.03.22.
//

import Foundation

extension String {

    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
