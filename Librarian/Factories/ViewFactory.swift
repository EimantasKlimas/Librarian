import UIKit

protocol ViewProviding {
    static func makeListViewController(_ coordinator: MainCoordinating) -> UIViewController
}

final public class ViewFactory: ViewProviding {
    static func makeListViewController(_ coordinator: MainCoordinating) -> UIViewController {
        return BookListsViewController(
            bookListViewModel: BookListsViewModel(
                dataActor: ActorFactory.makeDataActor(),
                persitanceActor: ActorFactory.makePersitanceActor(),
                coordinator: coordinator
            )
        )
    }
    
    static func makeBooksViewController(_ listID: Int,_ coordinator: MainCoordinating) -> UIViewController {
        return BooksViewController(
            booksViewModel: BooksViewModel(
                listID: listID,
                dataActor: ActorFactory.makeDataActor(),
                persitanceActor: ActorFactory.makePersitanceActor(),
                coordinator: coordinator
            )
        )
    }
    
    static func makeBookDetailViewController(_ bookDetails: BookWithDetail, _ coordinator: MainCoordinating) -> UIViewController {
        return BookDetailViewController(
            viewModel: BookDetailViewModel(
                bookDetails: bookDetails,
                dataActor: ActorFactory.makeDataActor(),
                coordinator: coordinator)
        )
    }
}
