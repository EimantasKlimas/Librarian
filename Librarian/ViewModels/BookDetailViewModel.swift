import UIKit

class BookDetailViewModel {
    private let dataActor: DataActing
    private let dateFormatter: DateFormatter = {
        let dateForamtter = DateFormatter()
        dateForamtter.dateFormat = "YY/MM/dd"
        
        return dateForamtter
    }()

    
    private var details: BookWithDetail
    private weak var coordinator: MainCoordinating!
    public weak var delegate: BookDetailInteracting?

    init(
        bookDetails: BookWithDetail,
        dataActor: DataActing,
        coordinator: MainCoordinating
    ) {
        self.details = bookDetails
        self.dataActor = dataActor
    }
    
    public func getImage() -> String { details.image }
    public func getTitle() -> String { details.title }
    public func getAuthor() -> String { details.author }
    public func getISBN() -> String { details.isbn ?? "" }
    public func getDescription() -> String { details.description }
    public func getPublicationDate() -> String { dateFormatter.string(from: details.publicationDate) }

    public func refreshBooks() {
        delegate?.startedUpdate()
        fetchBooks()
    }
        
    private func fetchBooks() {
        guard let delegate else {
            return
        }
        
        getBooks(delegate.didUpdate)
    }
    
    private func getBooks(_ completion: @escaping () -> Void) {
        Task {
            do {
                let bookWithDetails = try await dataActor.getBookDetail(for: details.id)
                guard let bookWithDetails else {
                    return
                }
                details = bookWithDetails
                
                completion()
                delegate?.didUpdate()
            } catch {
                coordinator.presentError(fetchBooks)
            }
        }
    }

}



