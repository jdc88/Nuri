//
//  ProductLoader.swift
//  Nuri
//
//  Created by Nicklaus Marietta on 12/14/25.
//

import Foundation
import CoreData

struct ProductImporter {
    static func importMasterListIfNeeded(context: NSManagedObjectContext) {
        let request: NSFetchRequest<AppProduct> = AppProduct.fetchRequest()
        request.fetchLimit = 1
        let count = (try? context.count(for: request)) ?? 0
        guard count == 0 else { return }

        let masterList = MasterDataLoader.load()

        for item in masterList {
            let newProduct = AppProduct(context: context)
            newProduct.id = item.id
            newProduct.name = item.name
            newProduct.brand = item.brand
            newProduct.last_updated_at = Date()
            newProduct.inciList = item.inciList
            newProduct.imageName = item.imageName
            newProduct.barcode = item.barcode

            try? CoreDataManager.processAndLinkIngredients(
                inciList: item.inciList,
                toProduct: newProduct,
                context: context
            )
        }

        try? context.save()
    }
}

