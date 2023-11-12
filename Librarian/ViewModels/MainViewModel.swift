import UIKit

class MainViewModel {
//    let datasource: MainViewDatasource = MainViewDatasource()
    let dataActor: DataActing
    weak var delegate: MainViewInteracting?
    
    init(
        dataActor: DataActing
    ) {
        self.dataActor = dataActor
        // No need to worry about race conditions thanks to using actors
        fetchLists()
        fetchBookDetails(for: 1)
    }
    
    public func refreshPosts() {
        delegate?.startedUpdate()
        fetchPosts()
    }
    
    private func fetchStoredPosts() {
        delegate?.startedUpdate()
//        getStoredUsers(datasource.updateUsers)
    }
    
    private func fetchLists() {
        getBookLists({ _ in print("+done")})
    }
    
    private func fetchDetails(for id: Int) {
        
    }
    
    private func fetchPosts() {
//        getUsers(datasource.updateUsers)
    }
    
    private func getBookLists(_ completion: @escaping (BookLists) -> Void) {
        Task {
            do {
                let bookLists = try await dataActor.getBookLists()
                let books = try await dataActor.getBooks()
                
                bookLists.forEach { l in
                    print("+AAA: \(l)")
                }
                books.forEach { b in
                    print("+BBB: \(b)")
                }
                
//                try await dataActor.save(posts: posts)
                
                completion(bookLists)
                delegate?.didUpdate()
            } catch {
                delegate?.didReceiveError(fetchPosts)
            }
        }
    }
    
    private func getBookDetails(for id: Int) {

    }
    
    private func fetchBookDetails(for id: Int) {
        print("+ init details fetch")
        Task {
            do {
                let details = try await dataActor.getBookDetail(for: id)
                
                print("+C: \(details)")
            } catch {
                print("+ ERROR: \(error)")
            }
        }
    }
    
//    private func getStoredUsers(_ completion: @escaping ([Post]) -> Void) {
//        Task {
//            let storedPosts = await dataActor.posts()
//            completion(storedPosts)
//            delegate?.didUpdate()
//        }
//    }
}



