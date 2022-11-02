import UIKit
import CommonCore

public extension UIView {

    weak var loadingView: LoadingView? {
        get {
            let view = subviews.first(where: { $0 is LoadingView })
            return view as? LoadingView
        }
        set {
            let oldView = self.loadingView

            guard let loadingView = newValue else {
                oldView?.removeFromSuperview()
                return
            }

            oldView?.removeFromSuperview()
            addViewToBoundsWithContraints(loadingView)
        }
    }

    func showLoading() {
        let view = LoadingView.instantiate()
        view.setup()
        loadingView = view
    }

    func hideLoading() {
        loadingView = nil
    }
}


