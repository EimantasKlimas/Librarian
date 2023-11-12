import UIKit

public class BookListsDatasource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private lazy var buttonAction: ((Int) -> Void)? = nil
    private lazy var lists: BookLists = []
    private lazy var books: Books = []
        
    public func updateLists(_ lists: BookLists, _ books: Books) {
        self.lists = lists
        self.books = books
    }
       
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lists.count
    }
        
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let list = lists[safe: indexPath.row],
              let cell = tableView.dequeueReusableCell(withIdentifier: "bookListCell", for: indexPath) as? BookListCell,
              let buttonAction
        else {
            return UITableViewCell()
        }
        
        let associatedBooks = Array(
            books
                .filter({$0.listID == list.id})
                .prefix(5)
        )

        cell.setup(
            with: list,
            and: associatedBooks,
            buttonAction
        )
        cell.selectionStyle = .none

        return cell
    }
}

public extension BookListsDatasource {
    func setButtonAction(_ action: @escaping (Int) -> Void) {
        self.buttonAction = action
    }
}
