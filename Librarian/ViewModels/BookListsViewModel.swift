import UIKit

class BookListsViewModel {
    
    private let dataActor: DataActing
    private let persitanceActor: PersistanceActing
    private weak var coordinator: MainCoordinating!
    
    public let datasource = BookListsDatasource()
    public weak var delegate: BookListViewInteracting?
    
    init(
        dataActor: DataActing,
        persitanceActor: PersistanceActing,
        coordinator: MainCoordinating
    ) {
        self.dataActor = dataActor
        self.persitanceActor = persitanceActor
        self.coordinator = coordinator
        datasource.setButtonAction(navigate(_:))
        fetchStoredLists()
        fetchLists()
    }
    
    public func refreshLists() {
        delegate?.startedUpdate()
        fetchLists()
    }
    
    private func fetchStoredLists() {
        delegate?.startedUpdate()
        getStoredLists(datasource.updateLists)
    }
    
    private func fetchLists() {
        getLists(datasource.updateLists)
    }
    
    private func getLists(_ completion: @escaping (BookLists, Books) -> Void) {
        Task {
            do {
                let lists = try await dataActor.getBookLists()
                let books = try await dataActor.getBooks()

                try await persitanceActor.saveBookLists(lists: lists)
                try await persitanceActor.saveBooks(books: books)
                                
                completion(lists.sorted(by: {$0.id < $1.id}), books)
                delegate?.didUpdate()
            } catch {
                coordinator.presentError(fetchLists)
            }
        }
    }
    
    private func getStoredLists(_ completion: @escaping (BookLists, Books) -> Void) {
        Task {
            do {
                let storedLists = try await persitanceActor.bookLists()
                let storedBooks = try await persitanceActor.books()
                
                completion(storedLists.sorted(by: {$0.id < $1.id}), storedBooks)
                delegate?.didUpdate()
            } catch {
                coordinator.presentError(fetchLists)
            }
        }
    }
    
    private func navigate(_ listId: Int) -> Void {
        coordinator.presentBookList(for: listId)
    }
}



