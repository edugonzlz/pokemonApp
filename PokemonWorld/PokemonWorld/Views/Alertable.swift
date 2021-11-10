import UIKit

public protocol Alertable {
    func showAlert(title: String, message: String)
}

public extension Alertable where Self: UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = AlertController.alert(title: title, message: message)
        
        present(alertController, animated: true, completion: nil)
    }
}

