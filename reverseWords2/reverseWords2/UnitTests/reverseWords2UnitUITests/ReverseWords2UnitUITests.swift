//
//  reverseWords2UnitUITests.swift
//  reverseWords2UnitUITests
//
//  Created by admin on 02.08.2024.
//

import XCTest
@testable import reverseWords2

class MainViewControllerUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testDefaultExclusionWithSimpleText() {
        let textField = app.textFields["textField"]
        textField.tap()
        textField.typeText("Foxminded cool 24/7")

        app.segmentedControls["segmentControl"].buttons["Default"].tap()

        let resultLabel = app.staticTexts["reverseText"]
        XCTAssertEqual(resultLabel.label, "dednimxoF looc 24/7")
    }

    func testCustomExclusionWithSimpleText() {
        let textField = app.textFields["textField"]
        textField.tap()
        textField.typeText("Foxminded cool 24/7")

        app.segmentedControls["segmentControl"].buttons["Custom"].tap()

        let customTextField = app.textFields["customTextField"]
        customTextField.tap()
        customTextField.typeText("xl")

        let resultLabel = app.staticTexts["reverseText"]
        XCTAssertEqual(resultLabel.label, "dexdnimoF oocl 7/42")
    }

    func testDefaultExclusionWithTextAndSpecialCharacters() {
        let textField = app.textFields["textField"]
        textField.tap()
        textField.typeText("abcd efgh")

        app.segmentedControls["segmentControl"].buttons["Default"].tap()

        let resultLabel = app.staticTexts["reverseText"]
        XCTAssertEqual(resultLabel.label, "dcba hgfe")
    }

    func testCustomExclusionWithTextAndSpecialCharacters() {
        let textField = app.textFields["textField"]
        textField.tap()
        textField.typeText("a1bcd efg!h")

        app.segmentedControls["segmentControl"].buttons["Custom"].tap()

        let customTextField = app.textFields["customTextField"]
        customTextField.tap()
        customTextField.typeText("xl")

        let resultLabel = app.staticTexts["reverseText"]
        XCTAssertEqual(resultLabel.label, "dcb1a hgf!e")
    }

    func testCustomExclusionWithAdditionalCharacters() {
        let textField = app.textFields["textField"]
        textField.tap()
        textField.typeText("a1bcd efglh")

        app.segmentedControls["segmentControl"].buttons["Custom"].tap()

        let customTextField = app.textFields["customTextField"]
        customTextField.tap()
        customTextField.typeText("xl")

        let resultLabel = app.staticTexts["reverseText"]
        XCTAssertEqual(resultLabel.label, "dcb1a hgfle")
    }
}
