import Foundation
import CoreData

extension BookListDTO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookListDTO> {
        return NSFetchRequest<BookListDTO>(entityName: "BookListDTO")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String

}

extension BookListDTO : Identifiable {

}
