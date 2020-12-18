//
//  ReviewsAppUITests.swift
//  ReviewsAppUITests
//

import XCTest

/*
 Intention is to check the app launch time
 */
class ReviewsAppUITests: XCTestCase {
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
