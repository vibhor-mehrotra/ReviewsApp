//
//  ReviewDataTests.swift
//  ReviewsAppTests
//

import XCTest
@testable import ReviewsApp
/*
 Intention is to check the ReviewData model parsing. The values present is JSON should be correctly parsed  and set in model.
 */
class ReviewDataTests: XCTestCase {
    var reviewDetail: ReviewsData!
    
    override func setUpWithError() throws {
        reviewDetail = MockData.reviewMockModel
    }

    override func tearDownWithError() throws {
        reviewDetail = nil
    }

    func testReviewsData() throws {
        XCTAssertNotNil(reviewDetail, "Review data model not set correctly.")
        XCTAssert(reviewDetail.totalCount == 1395, "totalCount not set correctly.")
        XCTAssert(reviewDetail.pagination?.limit == 20, "limit not set correctly.")
        XCTAssert(reviewDetail.pagination?.offset == 1, "offset not set correctly.")
        XCTAssert(reviewDetail.reviews!.count == 20, "Reviews count not correct")
        let firstReview = reviewDetail.reviews![0]
        XCTAssert(firstReview.title == "", "title not set correctly.")
        XCTAssert(firstReview.enjoyment == "", "enjoyment not set correctly.")
        XCTAssert(firstReview.rating == 5, "rating not set correctly.")
        XCTAssert(firstReview.created == "2020-03-07T01:05:16+01:00", "created not set correctly.")
        XCTAssert(firstReview.author?.fullName == "Lee", "author fullName not set correctly")
        XCTAssert(firstReview.author?.country == "United Kingdom", "author country not set correctly")
    }


}
