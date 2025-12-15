//
//  AppProduct+CoreDataProperties.swift
//  Nuri
//
//  Created by Nicklaus Marietta on 12/14/25.
//
//

import Foundation
import CoreData


extension AppProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppProduct> {
        return NSFetchRequest<AppProduct>(entityName: "AppProduct")
    }

    @NSManaged public var barcode: String?
    @NSManaged public var brand: String?
    @NSManaged public var id: UUID?
    @NSManaged public var last_updated_at: Date?
    @NSManaged public var name: String?
    @NSManaged public var inciList: String?
    @NSManaged public var ingredients: NSOrderedSet?
    @NSManaged public var savedBy: NSSet?

}

// MARK: Generated accessors for ingredients
extension AppProduct {

    @objc(insertObject:inIngredientsAtIndex:)
    @NSManaged public func insertIntoIngredients(_ value: Ingredient, at idx: Int)

    @objc(removeObjectFromIngredientsAtIndex:)
    @NSManaged public func removeFromIngredients(at idx: Int)

    @objc(insertIngredients:atIndexes:)
    @NSManaged public func insertIntoIngredients(_ values: [Ingredient], at indexes: NSIndexSet)

    @objc(removeIngredientsAtIndexes:)
    @NSManaged public func removeFromIngredients(at indexes: NSIndexSet)

    @objc(replaceObjectInIngredientsAtIndex:withObject:)
    @NSManaged public func replaceIngredients(at idx: Int, with value: Ingredient)

    @objc(replaceIngredientsAtIndexes:withIngredients:)
    @NSManaged public func replaceIngredients(at indexes: NSIndexSet, with values: [Ingredient])

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: Ingredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: Ingredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSOrderedSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSOrderedSet)

}

// MARK: Generated accessors for savedBy
extension AppProduct {

    @objc(addSavedByObject:)
    @NSManaged public func addToSavedBy(_ value: SavedProduct)

    @objc(removeSavedByObject:)
    @NSManaged public func removeFromSavedBy(_ value: SavedProduct)

    @objc(addSavedBy:)
    @NSManaged public func addToSavedBy(_ values: NSSet)

    @objc(removeSavedBy:)
    @NSManaged public func removeFromSavedBy(_ values: NSSet)

}

extension AppProduct : Identifiable {

}
