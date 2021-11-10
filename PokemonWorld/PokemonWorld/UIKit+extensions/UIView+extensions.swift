import UIKit

public extension UIView {
    static func instantiate(autolayout: Bool = true) -> Self {
        func instantiateUsingNib<T: UIView>(autolayout: Bool) -> T {
            let view = UINib(nibName: String(describing: self), bundle: nil)
                .instantiate(withOwner: nil, options: nil).first as! T
            view.translatesAutoresizingMaskIntoConstraints = !autolayout
            return view
        }
        return instantiateUsingNib(autolayout: autolayout)
    }
    
    @discardableResult
    func addViewToBoundsWithContraints(_ view: UIView) -> (top: NSLayoutConstraint, right: NSLayoutConstraint, bottom: NSLayoutConstraint, left: NSLayoutConstraint) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let top = topAnchor.constraint(equalTo: view.topAnchor)
        top.isActive = true
        let right = rightAnchor.constraint(equalTo: view.rightAnchor)
        right.isActive = true
        let bottom = bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottom.isActive = true
        let left = leftAnchor.constraint(equalTo: view.leftAnchor)
        left.isActive = true
        
        return (top: top, right: right, bottom: bottom, left: left)
    }
}
