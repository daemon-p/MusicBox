import UIKit

public protocol StoryboardLoadable {
    static var storybaordName: String { get }
    static var bundle: Bundle? { get }
}


public extension StoryboardLoadable where Self: AnyObject {
    static var bundle: Bundle? {
        return Bundle(for: self.self)
    }
}

protocol Identifierable {
    static var identifier: String { get }
}

extension Identifierable {
    static var identifier: String {
        return .init(describing: self)
    }
}

extension UIViewController: Identifierable {}

public extension StoryboardLoadable where Self: UIViewController {
    
     static func loadInstance() -> Self {
        
        return UIStoryboard(name: storybaordName, bundle: bundle)
            .instantiateViewController(withIdentifier: identifier)
            as! Self
    }
}
