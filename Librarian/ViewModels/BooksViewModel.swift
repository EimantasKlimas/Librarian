import UIKit

class BooksViewModel {
    
    private let listID: Int
    private let dataActor: DataActing
    private let persitanceActor: PersistanceActing
    private var bookDetailsCache: BooksWithDetail = []
    private weak var coordinator: MainCoordinating!
    
    public let datasource = BooksDatasource()
    public weak var delegate: BooksViewInteracting?

    init(
        listID: Int,
        dataActor: DataActing,
        persitanceActor: PersistanceActing,
        coordinator: MainCoordinating
    ) {
        self.listID = listID
        self.dataActor = dataActor
        self.persitanceActor = persitanceActor
        self.coordinator = coordinator
        datasource.setButtonAction(navigate(_:))
        fetchBooks()
    }
    
    public func refreshBooks() {
        delegate?.startedUpdate()
        fetchBooks()
    }
        
    private func fetchBooks() {
        getBooks(datasource.updateBooks)
    }
    
    private func getBooks(_ completion: @escaping (BooksWithDetail) -> Void) {
        Task {
            do {
                let books = try await dataActor.getBooks()
                let booksWithDetails = try await withThrowingTaskGroup(
                    of: BookWithDetail?.self,
                    returning: [BookWithDetail?].self) { taskGroup in
                        books
                            .filter({$0.listID == listID})
                            .forEach { book in
                                taskGroup.addTask { [weak self] in
                                    try await self?.dataActor.getBookDetail(for: book.id)
                                }
                            }
                        
                        var bookDetails = [BookWithDetail?]()
                        
                        for try await result in taskGroup {
                            bookDetails.append(result)
                        }
                        
                        return bookDetails.sorted(by: { (first, second) in
                            guard let first, let second else {
                                return false
                            }
                            return first.id < second.id
                        })
                    }
                
                try await persitanceActor.saveBooks(books: books)
                try await persitanceActor.saveBooksWithDetails(books: booksWithDetails)
                
                bookDetailsCache = booksWithDetails
                
                completion(booksWithDetails)
                delegate?.didUpdate()
            } catch {
                coordinator.presentError(fetchBooks)
            }
        }
    }
    
    private func getStoredBooks(_ completion: @escaping (BooksWithDetail) -> Void) {
        Task {
            do {
                let storedBooks = try await persitanceActor.booksWithDetails()
                
                completion(
                    storedBooks
                        .filter({$0?.listID == listID})
                        .sorted(by: { (first, second) in
                            guard let first, let second else {
                                return false
                            }
                            return first.id < second.id
                        })
                )
                delegate?.didUpdate()
            } catch {
                coordinator.presentError(fetchBooks)
            }
        }
    }
    
    private func navigate(_ bookId: Int) -> Void {
        guard let book = bookDetailsCache.first(where: { $0?.id == bookId}), let book else { return }
        
        coordinator.presentBookDetails(for: book)
    }
}



