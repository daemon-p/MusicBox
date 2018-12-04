public func &&<T>(_ left: Bool, _ right: @autoclosure () -> T) -> T? {
    return left ? right() : nil
}

public func ||<T>(_ left: Bool, _ right: @autoclosure () -> T) -> T? {
    return left ? nil : right()
}

public func &&<T>(_ left: T?, _ right: @autoclosure () -> T ) -> T? {
    return left == nil ? nil : right()
}

public func ||<T>(_ left: T?, _ right: @autoclosure () -> T) -> T? {
    return left ?? right()
}

