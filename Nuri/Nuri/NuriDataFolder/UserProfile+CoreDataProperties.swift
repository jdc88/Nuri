//
//  UserProfile+CoreDataProperties.swift
//  Nuri
//
//  Created by Nicklaus Marietta on 12/7/25.
//
//

import Foundation
import CoreData


extension UserProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }

    @NSManaged public var created_at: Date?
    @NSManaged public var skin_type: String?
    @NSManaged public var user_id: UUID?
    @NSManaged public var username: String?
    @NSManaged public var preferences: NSSet?
    @NSManaged public var savedProducts: NSSet?

}

// MARK: Generated accessors for preferences
extension UserProfile {

    @objc(addPreferencesObject:)
    @NSManaged public func addToPreferences(_ value: Preference)

    @objc(removePreferencesObject:)
    @NSManaged public func removeFromPreferences(_ value: Preference)

    @objc(addPreferences:)
    @NSManaged public func addToPreferences(_ values: NSSet)

    @objc(removePreferences:)
    @NSManaged public func removeFromPreferences(_ values: NSSet)

}

// MARK: Generated accessors for savedProducts
extension UserProfile {

    @objc(addSavedProductsObject:)
    @NSManaged public func addToSavedProducts(_ value: SavedProduct)

    @objc(removeSavedProductsObject:)
    @NSManaged public func removeFromSavedProducts(_ value: SavedProduct)

    @objc(addSavedProducts:)
    @NSManaged public func addToSavedProducts(_ values: NSSet)

    @objc(removeSavedProducts:)
    @NSManaged public func removeFromSavedProducts(_ values: NSSet)

}

extension UserProfile : Identifiable {

}
