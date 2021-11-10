import UIKit

public class LoadingView: UIView {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    
    public func setup() {
        backgroundColor = .clear
        containerView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        containerView.layer.cornerRadius = 10
        activityIndicator.color = .white
        self.isUserInteractionEnabled = true
    }
}
