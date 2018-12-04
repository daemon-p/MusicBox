import Foundation

extension NSObjectProtocol where Self: NSObject {
    
    public func observe<Value>(
        _ keyPath: KeyPath<Self, Value>,
        onChange: @escaping (Value) -> Void)
        -> NSKeyValueObservation {
            return observe(keyPath, options: [.initial, .new]) { _, change in

                guard let newValue = change.newValue else {
                    return
                }
                onChange(newValue)
            }
    }
    
    public func bind<Value, Target>(
        _ sourceKeyPath: KeyPath<Self, Value>,
        to target: Target,
        at targetKeyPath: ReferenceWritableKeyPath<Target, Value>)
        -> NSKeyValueObservation {
            return observe(sourceKeyPath) {
                target[keyPath: targetKeyPath] = $0
            }
    }
}
