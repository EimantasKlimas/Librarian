import Foundation
import CoreData

extension DetailDTO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DetailDTO> {
        return NSFetchRequest<DetailDTO>(entityName: "DetailDTO")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var publicationDate: Date
    @NSManaged public var author: String
    @NSManaged public var image: String
    @NSManaged public var descript: String
    @NSManaged public var isbn: String?
    @NSManaged public var listID: Int64
}

extension DetailDTO : Identifiable {

}
