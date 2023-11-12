import CoreData

protocol PersistanceActing: AnyObject {
    func saveBookLists(lists: BookLists) async throws
    func saveBooks(books: Books) async throws
    func saveBooksWithDetails(books: [BookWithDetail?]) async throws
    
    func bookLists() async throws -> BookLists
    func books() async throws -> Books
    func booksWithDetails() async throws -> BooksWithDetail
}

actor PersistanceActor: PersistanceActing {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.Container.name)
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      })
      return container
    }()
    
    func saveBookLists(lists: BookLists) async throws {
        let context = persistentContainer.viewContext
        lists.forEach { list in
            let listData = NSEntityDescription.insertNewObject(forEntityName: "BookListDTO", into: context) as! BookListDTO
            
            listData.id = Int64(list.id)
            listData.title = list.title
        }
        
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("Failed saving with :\(error)")
        }
    }
    
    func saveBooks(books: Books) async throws {
        let context = persistentContainer.viewContext
        books.forEach { book in
            let bookData = NSEntityDescription.insertNewObject(forEntityName: "BookDTO", into: context) as! BookDTO
            
            bookData.id = Int64(book.id)
            bookData.image = book.image
            bookData.listID = Int64(book.listID)
            bookData.title = book.title
        }
        
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("Failed saving with :\(error)")
        }
    }
    
    func saveBooksWithDetails(books: [BookWithDetail?]) async throws {
        let context = persistentContainer.viewContext
        books.forEach { book in
            guard let book else {
                return
            }
            let detailData = NSEntityDescription.insertNewObject(forEntityName: "DetailDTO", into: context) as! DetailDTO
            
            detailData.id = Int64(book.id)
            detailData.listID = Int64(book.listID)
            detailData.author = book.author
            detailData.descript = book.description
            detailData.image = book.image
            detailData.isbn = book.isbn
            detailData.publicationDate = book.publicationDate
            detailData.title = book.title
        }
        
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("Failed saving with :\(error)")
        }
    }
    
    func bookLists() async throws -> BookLists {
        let request: NSFetchRequest<BookListDTO> = BookListDTO.fetchRequest()
        var fetchedLists: [BookListDTO] = []
        
        do {
            fetchedLists = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Book Lists \(error)")
        }
        return convert(data: fetchedLists)
    }
    
    func books() async throws -> Books {
        let request: NSFetchRequest<BookDTO> = BookDTO.fetchRequest()
        var fetchedBooks: [BookDTO] = []
        
        do {
            fetchedBooks = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Books \(error)")
        }
        return convert(data: fetchedBooks)
    }
    
    func booksWithDetails() async throws -> BooksWithDetail{
        let request: NSFetchRequest<DetailDTO> = DetailDTO.fetchRequest()
        var fetchedBooks: [DetailDTO] = []
        
        do {
            fetchedBooks = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Books \(error)")
        }
        return convert(data: fetchedBooks)
    }
}

private extension PersistanceActor {
    func convert(data: [BookListDTO]) -> BookLists {
        data.map { listData in
            BookList(
                id: Int(listData.id),
                title: listData.title
            )
        }
    }
    
    func convert(data: [BookDTO]) -> Books {
        data.map { bookData in
            Book(
                id: Int(bookData.id),
                listID: Int(bookData.listID),
                title: bookData.title,
                image: bookData.image
            )
        }
    }
    
    func convert(data: [DetailDTO]) -> [BookWithDetail] {
        data.map { detailData in
            BookWithDetail(
                id: Int(detailData.id),
                listID: Int(detailData.listID),
                isbn: detailData.isbn,
                publicationDate: detailData.publicationDate,
                author: detailData.author,
                title: detailData.title,
                description: detailData.descript,
                image: detailData.image
            )
        }
    }
}
