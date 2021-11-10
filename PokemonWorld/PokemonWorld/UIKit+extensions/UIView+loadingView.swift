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

//    private static func setup(autolayout: Bool = true) -> Self {
//        func instantiateUsingNib<T: UIView>(autolayout: Bool) -> T {
//            let bundlePath = Bundle(for: LoadingView.self)
//                .path(forResource: "ResourcesBundle", ofType: "bundle")!
//            let bundle = Bundle(path: bundlePath)
//            let view = UINib(nibName: String(describing: self), bundle: bundle).instantiate(withOwner: nil, options: nil).first as! T
//            view.translatesAutoresizingMaskIntoConstraints = !autolayout
//            return view
//
//        }
//        return instantiateUsingNib(autolayout: autolayout)
//    }
}


