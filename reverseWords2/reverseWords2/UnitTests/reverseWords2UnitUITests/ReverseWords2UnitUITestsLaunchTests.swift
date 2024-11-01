//
//  reverseWords2UnitUITestsLaunchTests.swift
//  reverseWords2UnitUITests
//
//  Created by admin on 02.08.2024.
//

import XCTest
@testable import reverseWords2

final class ReverseWordsUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch_withTextFieldAndSegmentControlPresence() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.textFields["textField"].exists, "Text field should exist on launch.")
        
        XCTAssertTrue(app.segmentedControls["segmentControl"].exists, "Segment control should exist on launch.")
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
