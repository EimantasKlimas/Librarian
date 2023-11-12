import Foundation

public struct BookList: Codable {
    let id: Int
    let title: String
}

public struct Book: Codable {
    let id, listID: Int
    let title, image: String

    enum CodingKeys: String, CodingKey {
        case id
        case listID = "list_id"
        case image = "img"
        case title
    }
}

public struct BookWithDetail: Codable {
    let id, listID: Int
    let isbn: String?
    let publicationDate: Date
    let author, title, description, image: String

    enum CodingKeys: String, CodingKey {
        case id
        case listID = "list_id"
        case isbn
        case image = "img"
        case publicationDate = "publication_date"
        case author, title, description
    }
}

public typealias Books = [Book]
public typealias BookLists = [BookList]
public typealias BooksWithDetail = [BookWithDetail?]
