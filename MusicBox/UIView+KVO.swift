import UIKit

extension UIView {
    
    @objc var shadowColor: UIColor? {
        get {
            return layer.shadowColor.flatMap(UIColor.init)
        }set {
            layer.shadowColor = newValue?.cgColor
        }
    }
}

