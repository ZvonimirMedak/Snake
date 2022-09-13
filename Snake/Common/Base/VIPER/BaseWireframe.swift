import UIKit

protocol WireframeInterface: AnyObject {
    func openAlert(title: String?, message: String?, actions: [UIAlertAction], completion: (() -> Void)?, animated: Bool)
    func openAlert(_ alertController: UIAlertController, completion: (() -> Void)?, animated: Bool)
    func dismiss(animated: Bool)
    func popWireframe(animated: Bool)
    func popToRootWireframe(animated: Bool)
}

class BaseWireframe<ViewController> where ViewController: UIViewController {

    private unowned var _viewController: ViewController
    
    //to retain view controller reference upon first access
    private var temporaryStoredViewController: ViewController?

    init(viewController: ViewController) {
        temporaryStoredViewController = viewController
        _viewController = viewController
    }

}

extension WireframeInterface {

    func openAlert(title: String?, message: String?, actions: [UIAlertAction], completion: (() -> Void)? = nil, animated: Bool = true) {
        openAlert(title: title, message: message, actions: actions, completion: completion, animated: animated)
    }

    func openAlert(_ alertController: UIAlertController, completion: (() -> Void)? = nil, animated: Bool = true) {
        openAlert(alertController, completion: completion, animated: animated)
    }

    func dismiss(animated: Bool = true) {
        dismiss(animated: animated)
    }

    func popWireframe(animated: Bool = true) {
        popWireframe(animated: animated)
    }

    func popToRootWireframe(animated: Bool = true) {
        popToRootWireframe(animated: animated)
    }
}

extension BaseWireframe: WireframeInterface {

    func openAlert(title: String?, message: String?, actions: [UIAlertAction], completion: (() -> Void)?, animated: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach(alert.addAction)
        openAlert(alert, completion: completion, animated: animated)
    }

    func openAlert(_ alertController: UIAlertController, completion: (() -> Void)?, animated: Bool) {
        viewController.present(alertController, animated: animated, completion: completion)
    }
    
    func dismiss(animated: Bool) {
        viewController.dismiss(animated: animated)
    }

    func popWireframe(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }

    func popToRootWireframe(animated: Bool) {
        navigationController?.popToRootViewController(animated: animated)
    }
}

extension BaseWireframe {

    var viewController: ViewController {
        defer { temporaryStoredViewController = nil }
        return _viewController
    }

    var navigationController: UINavigationController? {
        return viewController.navigationController
    }

}

extension UIViewController {
    
    func presentWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>, animated: Bool = true, completion: (() -> Void)? = nil) {
        present(wireframe.viewController, animated: animated, completion: completion)
    }

}

extension UINavigationController {
    
    func pushWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>, animated: Bool = true) {
        pushViewController(wireframe.viewController, animated: animated)
    }
    
    func setRootWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>, animated: Bool = true) {
        setViewControllers([wireframe.viewController], animated: animated)
    }

}
