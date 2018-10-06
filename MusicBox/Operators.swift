func &&<T>(_ left: Bool, _ right: @autoclosure () -> T) -> T? {
    return left ? right() : nil
}

func ||<T>(_ left: Bool, _ right: @autoclosure () -> T) -> T? {
    return left ? nil : right()
}

func &&<T>(_ left: T?, _ right: @autoclosure () -> T ) -> T? {
    return left == nil ? nil : right()
}

func ||<T>(_ left: T?, _ right: @autoclosure () -> T) -> T? {
    return left ?? right()
}

