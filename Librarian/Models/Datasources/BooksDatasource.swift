import UIKit

public class BooksDatasource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private lazy var buttonAction: ((Int) -> Void)? = nil
    private lazy var books: BooksWithDetail = []
    
    public func updateBooks(_ books: BooksWithDetail) {
        self.books = books
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        books.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let bookWithDetails = books[safe: indexPath.row],
              let book = bookWithDetails,
              let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as? BooksCell
        else {
            return UITableViewCell()
        }
        
        cell.setup(with: book)
        cell.selectionStyle = .none
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedBook = books[safe: indexPath.row],
              let buttonAction,
              let selectedBook else {
            return
        }
        
        buttonAction(selectedBook.id)
    }
}

public extension BooksDatasource {
    func setButtonAction(_ action: @escaping (Int) -> Void) {
        self.buttonAction = action
    }
}
