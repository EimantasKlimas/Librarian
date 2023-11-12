//
//  BookDetailData+CoreDataProperties.swift
//  Librarian
//
//  Created by Eimantas Klimas on 11/11/2023.
//
//

import Foundation
import CoreData


extension BookDetailData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookDetailData> {
        return NSFetchRequest<BookDetailData>(entityName: "BookDetailData")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var listID: Int64
    @NSManaged public var isbn: String?

}

extension BookDetailData : Identifiable {

}
