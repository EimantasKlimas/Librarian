import UIKit

public class BookCoverView: UIImageView {
    init(_ coverUrl: String) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BookCoverView {
    func fetchAndSetImage(from url: String) {
        ImageLoaderActor.shared.get
    }
}
