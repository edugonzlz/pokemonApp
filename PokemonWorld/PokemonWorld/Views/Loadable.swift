import UIKit

public protocol Loadable {
    func showLoading()
    func hideLoading()
}

public extension Loadable where Self: UIViewController {
    func showLoading() {
        view.showLoading()
    }
    func hideLoading() {
        view.hideLoading()
    }
}
