import CoreData

protocol DataActing: AnyObject {
    func getBookLists() async throws -> BookLists
    func getBooks() async throws -> Books
    func getBookDetail(for id: Int) async throws -> BookWithDetail?
}

actor DataActor: DataActing {
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }()

    func getBookLists() async throws -> BookLists {
        guard let url = URL(string: Constants.Url.lists),
              let bookList: BookLists = try await fetch(from: url)
        else {
            return []
        }
                
        return bookList
    }
    
    func getBooks() async throws -> Books {
        guard let url = URL(string: Constants.Url.books),
              let books: Books = try await fetch(from: url)
        else {
            return []
        }
                
        return books
    }
    
    func getBookDetail(for id: Int) async throws -> BookWithDetail? {
        guard let url = URL(string: "\(Constants.Url.detail)\(id)"),
              let details: BookWithDetail = try await fetch(from: url)
        else {
            return nil
        }
                
        return details
    }
}

private extension DataActor {
    func fetch<T: Decodable>(from url: URL) async throws -> T {
        let request = URLRequest(url: url)
        
        let task: Task<T, Error> = Task {
            let (usersData, _) = try await URLSession.shared.data(for: request)
            let collection = try decoder.decode(T.self, from: usersData)
            return collection
        }
        
        return try await task.value
    }
}

