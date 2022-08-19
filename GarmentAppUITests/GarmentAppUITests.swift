import XCTest

class GarmentAppUITests: XCTestCase {
    func test() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["clear"].tap()
        XCTAssertTrue(app.tables.cells.count == 0, "there are preexisting cells")
        app.buttons["add"].tap()
        app.textFields["garment name"].tap()
        app.textFields["garment name"].typeText("Pants")
        app.buttons["save"].tap()
        XCTAssertTrue(app.cells.firstMatch.waitForExistence(timeout: 10), "could not find added garment")
        app.cells.firstMatch.tap()
        app.textFields["created"].tap()
        app.textFields["updated"].tap()
        app.textFields["garment name"].clearText()
        app.textFields["garment name"].tap()
        app.textFields["garment name"].typeText("Pants Updated")
        app.buttons["update"].tap()
        XCTAssertTrue(app.cells.firstMatch.waitForExistence(timeout: 10), "could not find updated garment")
        app.cells.firstMatch.tap()
        app.buttons["delete"].tap()
        
        XCTAssertTrue(app.tables.cells.count == 0, "garment not deleted properly")
    }
}

extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }
        
        var deleteString = String()
        for _ in stringValue {
            deleteString += XCUIKeyboardKey.delete.rawValue
        }
        self.doubleTap()
        self.typeText(deleteString)
    }
}
