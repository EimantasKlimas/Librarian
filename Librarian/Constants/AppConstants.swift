import UIKit

struct Constants {
    struct Styling {
        static let appColor = UIColor.systemBlue.withAlphaComponent(0.4)
        static let padding: CGFloat = 15
        static let buttonInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        static let stackSpacing: CGFloat = 10
        static let cornerRadius: CGFloat = 20
        static let thickBorder: CGFloat = 2
        static let thinBorder: CGFloat = 1
        static let buttonHeight: CGFloat = 50
        static let coverHeight: CGFloat = 175
        static let coverWidth: CGFloat = 150
        static let coverDetailHeight: CGFloat = 275
        static let coverDetailWidth: CGFloat = 250
        static let subtitleFontSize: CGFloat = 10
        static let titleFontSize: CGFloat = 30
    }
    
    struct Keys {
        static let imageCache = "ImageCache"
    }
    
    struct Container {
        static let name = "Librarian"
    }
    
    struct Url {
        static let lists = "https://my-json-server.typicode.com/KeskoSenukaiDigital/assignment/lists"
        static let books = "https://my-json-server.typicode.com/KeskoSenukaiDigital/assignment/books"
        static let detail = "https://my-json-server.typicode.com/KeskoSenukaiDigital/assignment/book/"
    }
    
    struct Text {
        static let button = "All"
    }
    
    struct Alert {
        static let title: String = "Data Fetch error"
        static let message: String = "An error has happened while fetching Books"
        static let retry: String = "Retry"
        static let cancel: String = "Cancel"
    }
    
    struct Resoure {
        static let defaultCover: String = "DefaultCover"
    }
}
