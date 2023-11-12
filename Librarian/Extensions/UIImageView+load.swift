import UIKit

public extension UIImageView {
    func load(from url: String) async throws -> UIImage? { try await ImageLoaderActor.shared.getImage(from: url) }
}
