//
//  Repetition.swift
//  Standard
//
//  Created by What on 2019/1/25.
//  Copyright © 2019 dumbass. All rights reserved.
//

public protocol Repetable {
    
    associatedtype Element = Self
    
    func `repeat`(_ repetition: () -> Void)
    func enumerate(_ enumerator: (Self.Element) -> Void)
}

extension Repetable where Self: FixedWidthInteger, Element == Self {
    
    public func asRange() -> Range<Self.Element> {
        return 0..<self
    }
    
    public func `repeat`(_ repetition: () -> Void) {
        asRange().forEach { _ in repetition() }
    }
    public func enumerate(_ enumerator: (Self.Element) -> Void) {
        asRange().forEach(enumerator)
    }
}

extension UInt8: Repetable {}
extension UInt16: Repetable {}
extension UInt32: Repetable {}
extension UInt64: Repetable {}
extension Int8: Repetable {}
extension Int16: Repetable {}
extension Int32: Repetable {}
extension Int64: Repetable {}
extension Int: Repetable {}

