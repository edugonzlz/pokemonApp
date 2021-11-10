import UIKit

public struct AlertController {
    public static func alert(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "OK", style: .default, handler: {_ in})
        alertController.addAction(acceptAction)
        
        return alertController
    }
}
