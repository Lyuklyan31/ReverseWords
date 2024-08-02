//
//  reverseWords2UnitTests.swift
//  reverseWords2UnitTests
//
//  Created by admin on 02.08.2024.
//

import XCTest
@testable import reverseWords2

class ReverseWordsServiceTests: XCTestCase {
    var reverseWordsService: ReverseWordsService!

    override func setUp() {
        super.setUp()
        reverseWordsService = ReverseWordsService()
    }

    override func tearDown() {
        reverseWordsService = nil
        super.tearDown()
    }

    func testDefaultBehaviorWithDigitsAndSpecialCharacters() {
        let result1 = reverseWordsService.reverseWords(in: "Foxminded cool 24/7", ignoring: [], reverseDigits: false, reverseSpecialCharacters: false, isCustomMode: false)
        XCTAssertEqual(result1, "dednimxoF looc 24/7", "Expected 'Foxminded cool 24/7' to be reversed to 'dednimxoF looc 24/7'")
        
        let result2 = reverseWordsService.reverseWords(in: "abcd efgh", ignoring: [], reverseDigits: false, reverseSpecialCharacters: false, isCustomMode: false)
        XCTAssertEqual(result2, "dcba hgfe", "Expected 'abcd efgh' to be reversed to 'dcba hgfe'")
        
        let result3 = reverseWordsService.reverseWords(in: "a1bcd efg!h", ignoring: [], reverseDigits: false, reverseSpecialCharacters: false, isCustomMode: false)
        XCTAssertEqual(result3, "d1cba hgf!e", "Expected 'a1bcd efg!h' to be reversed to 'd1cba hgf!e'")
    }

    func testCustomBehaviorWithDigitsAndSpecialCharacters() {
        let result1 = reverseWordsService.reverseWords(in: "Foxminded cool 24/7", ignoring: ["xl"], reverseDigits: true, reverseSpecialCharacters: true, isCustomMode: true)
        XCTAssertEqual(result1, "dexdnimoF oocl 7/42", "Expected 'Foxminded cool 24/7' to be reversed to 'dexdnimoF oocl 7/42'")
        
        let result2 = reverseWordsService.reverseWords(in: "abcd efgh", ignoring: ["xl"], reverseDigits: true, reverseSpecialCharacters: true, isCustomMode: true)
        XCTAssertEqual(result2, "dcba hgfe", "Expected 'abcd efgh' to be reversed to 'dcba hgfe'")
        
        let result3 = reverseWordsService.reverseWords(in: "a1bcd efglh", ignoring: ["xl"], reverseDigits: true, reverseSpecialCharacters: true, isCustomMode: true)
        XCTAssertEqual(result3, "dcb1a hgfle", "Expected 'a1bcd efglh' to be reversed to 'dcb1a hgfle'")
    }
}
