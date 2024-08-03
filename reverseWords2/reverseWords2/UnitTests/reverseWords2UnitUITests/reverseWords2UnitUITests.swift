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

    func testDefaultExclusion() {
        let textField = app.textFields["textField"]
        textField.tap()
        textField.typeText("Foxminded cool 24/7")

        app.segmentedControls["segmentControl"].buttons["Default"].tap()

        let resultLabel = app.staticTexts["reverseText"]
        XCTAssertEqual(resultLabel.label, "dednimxoF looc 24/7")
    }

    func testCustomExclusion() {
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

    func testDefaultExclusionSecond() {
        let textField = app.textFields["textField"]
        textField.tap()
        textField.typeText("abcd efgh")

        app.segmentedControls["segmentControl"].buttons["Default"].tap()

        let resultLabel = app.staticTexts["reverseText"]
        XCTAssertEqual(resultLabel.label, "dcba hgfe")
    }

    func testCustomExclusionSecond() {
        let textField = app.textFields["textField"]
        textField.tap()
        textField.typeText("a1bcd efg!h")

        app.segmentedControls["segmentControl"].buttons["Default"].tap()

        let resultLabel = app.staticTexts["reverseText"]
        XCTAssertEqual(resultLabel.label, "d1cba hgf!e")
    }

    func testCustomExclusionThird() {
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
