//
//  ListItemData+CoreDataProperties.swift
//  Librarian
//
//  Created by Eimantas Klimas on 11/11/2023.
//
//

import Foundation
import CoreData


extension ListItemData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListItemData> {
        return NSFetchRequest<ListItemData>(entityName: "ListItemData")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var publicationDate: Date?
    @NSManaged public var author: String?
    @NSManaged public var image: NSObject?
    @NSManaged public var descript: String?

}

extension ListItemData : Identifiable {

}
