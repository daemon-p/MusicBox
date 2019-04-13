//
//  ParserTests.swift
//  StandardTests
//
//  Created by What on 2019/2/16.
//  Copyright © 2019 dumbass. All rights reserved.
//

import XCTest
@testable import Standard

class ParserTest: XCTestCase {
    
    let digitsParser: Parser<Substring, Character> = element(matching: CharacterSet.decimalDigits.contains(_:))
//    let multiParser: Parser<Substring, Character> = element { $0 == "*" }

    let input0: Substring = "12334"
    let input1: Substring = "9aw"
    let input2: Substring = "👩‍👩‍👧‍👦👨🏻abc"
    let input3: Substring = "as"
    
    func testCharacterSet() {
        
        let digits = CharacterSet.decimalDigits
        input0.forEach {
            XCTAssertTrue(digits.contains($0))
        }
        
        input2.forEach {
            XCTAssertFalse(digits.contains($0))
        }
    }
    
    func testFuncElement() {
        
        [input0, input1].forEach {
            XCTAssertNotNil(digitsParser.parse($0))
        }
        
        [input2, input3].forEach {
            XCTAssertNil(digitsParser.parse($0))
        }
    }
    
    func testFuncRun() {
        
        [input0, input1].forEach {
            XCTAssertNotNil(digitsParser.run($0))
        }
        
        [input2, input3].forEach {
            XCTAssertNil(digitsParser.run($0))
        }
    }
    
    func testFuncMany() {
        XCTAssertEqual(5, digitsParser.many.run(input0)?.0.count)
        XCTAssertEqual(1, digitsParser.many.run(input1)?.0.count)
        XCTAssertEqual(0, digitsParser.many.run(input2)?.0.count)
        XCTAssertEqual(0, digitsParser.many.run(input3)?.0.count)
    }
    
    func testFuncMap() {
        XCTAssertEqual(UInt8(String(input0.first!))!, digitsParser.map { UInt8(String($0)) }.run(input0)?.0)
        XCTAssertEqual(UInt8(String(input1.first!))!, digitsParser.map { UInt8(String($0)) }.run(input1)?.0)
        XCTAssertEqual(String(input1.first!) + "_", digitsParser.map { String($0) + "_"}.run(input1)?.0)
        XCTAssertEqual(input0, digitsParser.many.map(Substring.init).run(input0)?.0)
    }
}
