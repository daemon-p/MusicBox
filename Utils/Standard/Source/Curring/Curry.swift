//
//  Curry.swift
//  Standard
//
//  Created by What on 2019/2/17.
//  Copyright © 2019 dumbass. All rights reserved.
//

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in { f(a, $0) } }
}

func curry<A, B, C, D>(_ f: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
    return { a in { b in { f(a, b, $0) } } }
}
