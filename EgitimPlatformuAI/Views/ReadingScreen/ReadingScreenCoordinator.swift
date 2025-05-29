import Foundation
import UIKit

public final class ReadingScreenCoordinator: Coordinator {
    private static var instance: ReadingScreenCoordinator?
    
    static func getInstance() -> ReadingScreenCoordinator {
        if instance == nil {
            instance = ReadingScreenCoordinator()
        }
        return instance!
    }
    
    var navigationController = UINavigationController()
    
    func start() {
        let storyboard = UIStoryboard(name: "ReadingScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ReadingScreen")
                as? ReadingScreenViewController else {
            fatalError("Failed to instantiate ReadingScreenViewController")
        }
        
        let viewModel = ReadingScreenViewModel(coordinator: self)
        viewController.viewModel = viewModel
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func start(with viewModel: ReadingScreenViewModel) {
        let storyboard = UIStoryboard(name: "ReadingScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ReadingScreen") as? ReadingScreenViewController else {
            fatalError("Failed to instantiate ReadingScreenViewController")
        }

        viewController.viewModel = viewModel

        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        }
    }
    
    
}
