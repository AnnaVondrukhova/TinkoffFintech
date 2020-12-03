//
//  TinkoffFintechUITests.swift
//  TinkoffFintechUITests
//
//  Created by Anya on 02.12.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

@testable import TinkoffFintech
import XCTest

class TinkoffFintechUITests: XCTestCase {

    func testTextFieldExistence() {
        
        let app = XCUIApplication()
        app.launch()

        app.navigationBars["Tinkoff Chat"].buttons["profileButton"].tap()

        let textField = app.textFields.element(boundBy: 0)
        let textView = app.textViews.element(boundBy: 0)
        _ = textField.waitForExistence(timeout: 3.0)
        _ = textView.waitForExistence(timeout: 3.0)

        XCTAssertTrue(textField.exists)
        XCTAssertTrue(textView.exists)
    }
}
