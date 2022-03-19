//
//  Record+CoreDataProperties.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 19.03.22.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var artist: String
    @NSManaged public var name: String
    @NSManaged public var releaseDate: Date
    @NSManaged public var uuid: UUID

}

extension Record : Identifiable {

}
