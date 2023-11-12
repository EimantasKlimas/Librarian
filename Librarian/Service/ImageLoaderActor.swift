import UIKit

// Caching can also be done with NSCache or simply storing in memory
protocol ImageLoaderActing {
    func getImage(from urlString: String) async throws -> UIImage?
}

actor ImageLoaderActor: ImageLoaderActing {
    static let shared = ImageLoaderActor()
    
    func getImage(from urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        let request = URLRequest(url: url)
        
        let task: Task<UIImage, Error> = Task {
            let (imageData, _) = try await URLSession.shared.data(for: request)
            let image = UIImage(data: imageData)!
            try await storeImage(image, from: urlString)
            return image
        }
        
        return try await task.value
    }
}


private extension ImageLoaderActor {
    func storeImage( _ image: UIImage, from urlString: String) async throws {
        let path = NSTemporaryDirectory().appending(UUID().uuidString)
        let url = URL(fileURLWithPath: path)
        
        let data = image.jpegData(compressionQuality: 0.5)
        try? data?.write(to: url)
        
        var dict = UserDefaults.standard.object(forKey: Constants.Keys.imageCache) as? [String:String]
        if dict == nil {
            dict = [String: String]()
        }
        
        dict![urlString] = path
        UserDefaults.standard.setValue(dict, forKey: Constants.Keys.imageCache)
    }
}
