protocol Identifierable {
    static var identifier: String { get }
}

extension Identifierable {
    static var identifier: String {
        return .init(describing: self)
    }
}
