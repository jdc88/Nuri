//
//  Preference+CoreDataProperties.swift
//  Nuri
//
//  Created by Nicklaus Marietta on 12/7/25.
//
//

import Foundation
import CoreData


extension Preference {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Preference> {
        return NSFetchRequest<Preference>(entityName: "Preference")
    }

    @NSManaged public var classification: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var type: String?
    @NSManaged public var ingredient: Ingredient?
    @NSManaged public var user: UserProfile?

}

extension Preference : Identifiable {

}
