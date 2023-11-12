//
//  BookData+CoreDataProperties.swift
//  Librarian
//
//  Created by Eimantas Klimas on 11/11/2023.
//
//

import Foundation
import CoreData


extension BookData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookData> {
        return NSFetchRequest<BookData>(entityName: "BookData")
    }

    @NSManaged public var id: Int64
    @NSManaged public var listID: Int64
    @NSManaged public var title: String?
    @NSManaged public var image: String?

}

extension BookData : Identifiable {

}
