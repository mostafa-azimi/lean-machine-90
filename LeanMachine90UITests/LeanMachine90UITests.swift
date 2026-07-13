import XCTest

final class LeanMachine90UITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testFoundationLaunchesOnToday() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.navigationBars["Today"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Your plan, one day at a time."].exists)
        XCTAssertTrue(app.tabBars.buttons["Plan"].exists)
        XCTAssertTrue(app.tabBars.buttons["Progress"].exists)
    }
}
