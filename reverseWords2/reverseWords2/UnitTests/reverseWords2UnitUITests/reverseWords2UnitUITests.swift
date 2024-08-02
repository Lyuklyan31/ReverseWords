//
//  reverseWords2UnitUITests.swift
//  reverseWords2UnitUITests
//
//  Created by admin on 02.08.2024.
//

import XCTest
@testable import reverseWords2

final class ReverseWordsUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testReverseWordsFunctionality() throws {
        let textField = app.textFields["textFieldIdentifier"]
        let reverseButton = app.buttons["actionButtonIdentifier"]
        let reversedLabel = app.staticTexts["reverseTextIdentifier"]
        
        XCTAssertTrue(textField.waitForExistence(timeout: 5), "Text field does not exist.")
        
        textField.tap()
        textField.typeText("Hello World")
        closeKeyboard()
        
        // Debug: Check if reverseButton is found and visible
        if reverseButton.exists {
            XCTAssertTrue(reverseButton.isHittable, "Reverse button is not hittable.")
        } else {
            XCTFail("Reverse button does not exist.")
        }
        
        reverseButton.tap()
        
        // Use a different query if StaticText fails
        let reversedLabelExists = reversedLabel.waitForExistence(timeout: 5)
        
        if reversedLabelExists {
            XCTAssertEqual(reversedLabel.label, "olleH dlroW", "Expected reversed label text to be 'olleH dlroW'.")
        } else {
            XCTFail("Reversed label does not exist or cannot be found.")
        }
        
        reverseButton.tap()
    }

    func closeKeyboard() {
        app.keyboards.buttons["Return"].tap()
    }
}

private extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }

        self.tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
    }
}
