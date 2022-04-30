//
//  SearchCategory.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 23.04.22.
//

import Foundation
import UIKit

struct SearchCategory: Hashable {
    let uuid: UUID = UUID()
    var name: String = "Category"
    var image: UIImage? 
}
