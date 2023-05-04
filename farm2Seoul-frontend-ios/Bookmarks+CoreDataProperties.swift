//
//  Bookmarks+CoreDataProperties.swift
//  
//
//  Created by 강보현 on 2023/05/03.
//
//

import Foundation
import CoreData


extension Bookmarks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bookmarks> {
        return NSFetchRequest<Bookmarks>(entityName: "Bookmarks")
    }

    @NSManaged public var productName: String?

}
