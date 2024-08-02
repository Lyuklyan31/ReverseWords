//
//  reverseWords2UnitTests.swift
//  reverseWords2UnitTests
//
//  Created by admin on 02.08.2024.
//

import XCTest
@testable import reverseWords2

final class ReverseWordsTests: XCTestCase {
    
    var reverseWordsService: ReverseWordsService!
    
    override func setUpWithError() throws {
        reverseWordsService = ReverseWordsService()
    }

    override func tearDownWithError() throws {
        reverseWordsService = nil
    }

    func testReverseWords() throws {
        // Test case with a single word
        let singleWord = "Test"
        let reversedSingleWord = reverseWordsService.reverseWords(in: singleWord)
        XCTAssertEqual(reversedSingleWord, "tseT", "The word should be reversed correctly.")
        
        // Test case with multiple words
        let multipleWords = "Test string"
        let reversedMultipleWords = reverseWordsService.reverseWords(in: multipleWords)
        XCTAssertEqual(reversedMultipleWords, "tseT gnirts", "Each word in the sentence should be reversed correctly.")
        
        // Test case with empty string
        let emptyString = ""
        let reversedEmptyString = reverseWordsService.reverseWords(in: emptyString)
        XCTAssertEqual(reversedEmptyString, "", "Reversing an empty string should return an empty string.")
        
        // Test case with special characters
        let specialCharacters = "Test, string!"
        let reversedSpecialCharacters = reverseWordsService.reverseWords(in: specialCharacters)
        XCTAssertEqual(reversedSpecialCharacters, ",tseT !gnirts", "Special characters should remain in their positions relative to words.")
    }
    
    func testPerformanceExample() throws {
        measure {
            _ = reverseWordsService.reverseWords(in: "This is a performance test case to measure the time of reversing words.")
        }
    }
}
