//
//  Preference+CoreDataProperties.swift
//  Nuri
//
//  Created by Nicklaus Marietta on 12/16/25.
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
    @NSManaged public var preferredIngredients: NSSet?

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

// MARK: Generated accessors for preferredIngredients
extension Preference {

    @objc(addPreferredIngredientsObject:)
    @NSManaged public func addToPreferredIngredients(_ value: Ingredient)

    @objc(removePreferredIngredientsObject:)
    @NSManaged public func removeFromPreferredIngredients(_ value: Ingredient)

    @objc(addPreferredIngredients:)
    @NSManaged public func addToPreferredIngredients(_ values: NSSet)

    @objc(removePreferredIngredients:)
    @NSManaged public func removeFromPreferredIngredients(_ values: NSSet)

}

extension Preference : Identifiable {

}
