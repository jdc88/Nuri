//
//  Preference+CoreDataProperties.swift
//  Nuri
//
//  Created by Nicklaus Marietta on 12/14/25.
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
    @NSManaged public var avoidedIngredients: NSSet?
    @NSManaged public var user: UserProfile?

}

// MARK: Generated accessors for avoidedIngredients
extension Preference {

    @objc(addAvoidedIngredientsObject:)
    @NSManaged public func addToAvoidedIngredients(_ value: Ingredient)

    @objc(removeAvoidedIngredientsObject:)
    @NSManaged public func removeFromAvoidedIngredients(_ value: Ingredient)

    @objc(addAvoidedIngredients:)
    @NSManaged public func addToAvoidedIngredients(_ values: NSSet)

    @objc(removeAvoidedIngredients:)
    @NSManaged public func removeFromAvoidedIngredients(_ values: NSSet)

}

extension Preference : Identifiable {

}
