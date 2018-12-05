import UIKit

extension UIViewController: Identifierable {}

public protocol StoryboardRepresentable {
    static var sbName: String { get }
    static var sbBundle: Bundle? { get }
}

public extension StoryboardRepresentable where Self: AnyObject {
    static var sbBundle: Bundle? {
        return Bundle(for: self.self)
    }
}

extension StoryboardRepresentable where Self: UIViewController {
    
     public static func loadInstance() -> Self {
        return UIStoryboard(name: sbName, bundle: sbBundle).instantiateViewController(withIdentifier: identifier) as! Self
    }
}
