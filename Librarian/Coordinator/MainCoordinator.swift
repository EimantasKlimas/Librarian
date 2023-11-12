import UIKit
import Combine

protocol MainCoordinating: AnyObject {
    func coordinate(with scene: UIWindowScene)
    func presentBookList(for id: Int)
    func presentBookDetails(for details: BookWithDetail)
    func presentError(_ completion: @escaping () -> Void)
}

final public class MainCoordintor: MainCoordinating {
    var navigationController: UINavigationController?
    var window: UIWindow?
    var cancellables = Set<AnyCancellable>()
    
    func coordinate(with scene: UIWindowScene) {
        navigationController = UINavigationController(
            rootViewController: ViewFactory.makeListViewController(self)
        )
        
        window = WindowFactory.makeMainWindow()
        window?.windowScene = scene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func presentBookList(for id: Int) {
        let viewController = ViewFactory.makeBooksViewController(id, self)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentBookDetails(for details: BookWithDetail) {
        let viewController = ViewFactory.makeBookDetailViewController(details, self)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentError(_ completion: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alert = UIAlertController(
                title: Constants.Alert.title,
                message: Constants.Alert.message,
                preferredStyle: UIAlertController.Style.alert
            )
            
            alert.addAction(
                UIAlertAction(
                    title: Constants.Alert.cancel,
                    style: UIAlertAction.Style.default,
                    handler: nil
                )
            )
            alert.addAction(
                UIAlertAction(
                    title: Constants.Alert.retry,
                    style: UIAlertAction.Style.default,
                    handler: { _ in
                        Task {
                            completion()
                        }
                    }
                )
            )
            
            self.navigationController?.present(alert, animated: true)
        }
    }
}

