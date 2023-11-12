import Foundation
import CoreData

extension BookDTO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookDTO> {
        return NSFetchRequest<BookDTO>(entityName: "BookDTO")
    }

    @NSManaged public var id: Int64
    @NSManaged public var listID: Int64
    @NSManaged public var title: String
    @NSManaged public var image: String

}

extension BookDTO : Identifiable {

}
