//
//  SavedProduct+CoreDataProperties.swift
//  Nuri
//
//  Created by Nicklaus Marietta on 12/7/25.
//
//

import Foundation
import CoreData


extension SavedProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedProduct> {
        return NSFetchRequest<SavedProduct>(entityName: "SavedProduct")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var note: String?
    @NSManaged public var saved_at: Date?
    @NSManaged public var product: AppProduct?
    @NSManaged public var user: UserProfile?

}

extension SavedProduct : Identifiable {

}
