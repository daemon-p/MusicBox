import UIKit

extension UIView: Identifierable {}

public protocol NibPresentable {
    
    static var usingMainBundle: Bool { get }
    static var nibName: String { get }
    static var nibBundle: Bundle? { get }
    static var nibIndex: Int? { get }
    static var nibOptions: [UINib.OptionsKey : Any]? { get }
}

public extension NibPresentable where Self: AnyObject {
    
    static var nibBundle: Bundle? {
        return usingMainBundle ? .main : Bundle(for: self.self)
    }
}

public extension NibPresentable {

    static var usingMainBundle: Bool {
        return false
    }
    
    static var nibName: String {
        return .init(describing: self)
    }
    
    static var nibIndex: Int? {
        return nil
    }
    
    static var nibOptions: [UINib.OptionsKey : Any]? {
        return nil
    }    
}

extension NibPresentable where Self: UIView {
    
    public static func nibInstance() -> Self? {
        
        
        let nibInstances = nibBundle?.loadNibNamed(nibName, owner: self, options: nibOptions)
        if let idx = nibIndex {
            return nibInstances?[idx] as? Self
        }
        
        return nibInstances?.first { $0 is Self } as? Self
    }
}
