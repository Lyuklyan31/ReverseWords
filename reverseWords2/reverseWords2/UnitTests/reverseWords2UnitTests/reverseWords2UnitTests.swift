//
//  reverseWords2UnitTests.swift
//  reverseWords2UnitTests
//
//  Created by admin on 02.08.2024.
//

import XCTest
@testable import reverseWords2

class ReverseWordsServiceTests: XCTestCase {
    var service: ReverseWordsService!

    override func setUp() {
        super.setUp()
        service = ReverseWordsService()
    }

    override func tearDown() {
        service = nil
        super.tearDown()
    }

    func testDefaultExclusion() {
        let input = "Foxminded cool 24/7"
        let expectedOutput = "dednimxoF looc 24/7"
        let result = service.reverseWords(in: input, ignoring: [], reverseDigits: false, reverseSpecialCharacters: false, isCustomMode: false, ignoreCharacters: [])
        XCTAssertEqual(result, expectedOutput)
    }

    func testCustomExclusion() {
        let input = "Foxminded cool 24/7"
        let expectedOutput = "dexdnimoF oocl 7/42"
        let result = service.reverseWords(in: input, ignoring: [], reverseDigits: true, reverseSpecialCharacters: true, isCustomMode: true, ignoreCharacters: ["x", "l"])
        XCTAssertEqual(result, expectedOutput)
    }

    func testDefaultExclusionSecond() {
        let input = "abcd efgh"
        let expectedOutput = "dcba hgfe"
        let result = service.reverseWords(in: input, ignoring: [], reverseDigits: false, reverseSpecialCharacters: false, isCustomMode: false, ignoreCharacters: [])
        XCTAssertEqual(result, expectedOutput)
    }

    func testCustomExclusionSecond() {
        let input = "a1bcd efg!h"
        let expectedOutput = "d1cba hgf!e"
        let result = service.reverseWords(in: input, ignoring: [], reverseDigits: false, reverseSpecialCharacters: false, isCustomMode: false, ignoreCharacters: [])
        XCTAssertEqual(result, expectedOutput)
    }

    func testCustomExclusionThird() {
        let input = "a1bcd efglh"
        let expectedOutput = "dcb1a hgfle"
        let result = service.reverseWords(in: input, ignoring: [], reverseDigits: true, reverseSpecialCharacters: true, isCustomMode: true, ignoreCharacters: ["x", "l"])
        XCTAssertEqual(result, expectedOutput)
    }
}
