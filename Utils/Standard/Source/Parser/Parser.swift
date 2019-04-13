//
//  Parser.swift
//  Standard
//
//  Created by What on 2019/2/16.
//  Copyright © 2019 dumbass. All rights reserved.
//

public struct Parser<S: Collection, E> {

    public typealias Sub = S.SubSequence
    
    public let parse: (Sub) -> (E, Sub)?
}

public func element<S: Sequence>(matching condition: @escaping (S.Element) -> Bool) -> Parser<S, S.Element> {
    return Parser {
        guard let ele = $0.first, condition(ele) else { return nil }
        return (ele, $0.dropFirst())
    }
}

public extension CharacterSet {
    func contains(_ c: Character) -> Bool {
        let scalars = String(c).unicodeScalars
        guard scalars.count == 1 else { return false }
        return contains(scalars.first!)
    }
}

public extension Parser {
    
    func run(_ input: S.SubSequence) -> (E, Sub)? {
        return parse(input)
    }

    var many: Parser<S, [E]> {
        return Parser<S, [E]> {
            var result: [E] = []; var reminder = $0
            while let (e, sub) = self.parse(reminder) {
                result.append(e); reminder = sub
            }
            return (result, reminder)
        }
    }
    
    func map<T>(_ transform: @escaping (E) -> T) -> Parser<S, T> {
        return Parser<S, T> {
            self.parse($0).flatMap { (transform($0), $1) }
        }
    }
    
    func followd<B>(by parser: Parser<S, B>) -> Parser<S, (E, B)> {
        
        func parse(ele: E, sequence: S.SubSequence) -> ((E, B), S.SubSequence)? {
            return parser.parse(sequence).flatMap { ((ele, $0.0), $0.1) }
        }
        
        return Parser<S, (E, B)> {
            self.parse($0).flatMap(parse(ele:sequence:))
        }
    }    
}
