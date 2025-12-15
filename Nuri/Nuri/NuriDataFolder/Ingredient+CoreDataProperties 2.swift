//
//  Ingredient+CoreDataProperties.swift
//  Nuri
//
//  Created by Nicklaus Marietta on 12/14/25.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var display_name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isAllergen: Bool
    @NSManaged public var lowercase_name: String?
    @NSManaged public var products: NSSet?
    @NSManaged public var avoidingPreference: Preference?

}

// MARK: Generated accessors for products
extension Ingredient {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: AppProduct)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: AppProduct)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}

extension Ingredient : Identifiable {

}
