//
//  DetailData+CoreDataProperties.swift
//  Librarian
//
//  Created by Eimantas Klimas on 11/11/2023.
//
//

import Foundation
import CoreData


extension DetailData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DetailData> {
        return NSFetchRequest<DetailData>(entityName: "DetailData")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var publicationDate: Date
    @NSManaged public var author: String
    @NSManaged public var image: String
    @NSManaged public var descript: String

}

extension DetailData : Identifiable {

}
