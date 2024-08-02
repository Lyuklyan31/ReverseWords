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
        let segmentControl = app.segmentedControls["segmentControlIdentifier"]
        let reversedLabel = app.staticTexts["reverseTextIdentifier"]

        XCTAssertTrue(textField.waitForExistence(timeout: 5), "Text field does not exist.")
        XCTAssertTrue(segmentControl.waitForExistence(timeout: 5), "Segment control does not exist.")

        textField.tap()
        textField.typeText("Hello World / Test")
        closeKeyboard()

        XCTAssertTrue(segmentControl.buttons.element(boundBy: 0).isSelected, "Default segment should be selected.")
        XCTAssertTrue(reversedLabel.waitForExistence(timeout: 5), "Reversed label does not exist.")
        XCTAssertEqual(reversedLabel.label, "olleH dlroW / tseT", "Expected reversed label text to be 'olleH dlroW / tseT' with '/' not reversed.")

        segmentControl.buttons.element(boundBy: 1).tap()
        XCTAssertTrue(segmentControl.buttons.element(boundBy: 1).isSelected, "Custom segment should be selected.")

        let customTextField = app.textFields["customTextFieldIdentifier"]
        XCTAssertTrue(customTextField.waitForExistence(timeout: 5), "Custom text field does not exist.")
        customTextField.tap()
        customTextField.clearText()
        customTextField.typeText("Hello / World")
        closeKeyboard()

        textField.tap()
        textField.clearText()
        textField.typeText("Swift / iOS")
        closeKeyboard()

        XCTAssertTrue(reversedLabel.waitForExistence(timeout: 5), "Reversed label does not exist.")
        XCTAssertEqual(reversedLabel.label, "tfiwS / SOi", "Expected reversed label text to be 'tfiwS / SOi' with '/' reversed.")

        textField.tap()
        textField.clearText()
        closeKeyboard()
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
