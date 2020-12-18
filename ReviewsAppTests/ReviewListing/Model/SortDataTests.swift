//
//  SortDataTests.swift
//  ReviewsAppTests
//

import XCTest
@testable import ReviewsApp
/*
 Intention is to check the Sort enum parsing. The value corresponding to each enum that is passed in API should be correct
 */
class SortDataTests: XCTestCase {
    var sortValue: Sort?

    override func tearDownWithError() throws {
        sortValue = nil
    }

    func testSortEnum() throws {
        sortValue = .mostLatestFirst
        XCTAssert(sortValue?.apiObject() == "date:desc", "Most recent first value not correct")
        
        sortValue = .mostNegativeFirst
        XCTAssert(sortValue?.apiObject() == "rating:asc", "Most negative first value not correct")
        
        sortValue = .mostPositiveFirst
        XCTAssert(sortValue?.apiObject() == "rating:desc", "Most positive first value not correct")
    }

}
