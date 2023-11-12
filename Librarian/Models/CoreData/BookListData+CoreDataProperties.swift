//
//  BookListData+CoreDataProperties.swift
//  Librarian
//
//  Created by Eimantas Klimas on 11/11/2023.
//
//

import Foundation
import CoreData


extension BookListData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookListData> {
        return NSFetchRequest<BookListData>(entityName: "BookListData")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String

}

extension BookListData : Identifiable {

}
