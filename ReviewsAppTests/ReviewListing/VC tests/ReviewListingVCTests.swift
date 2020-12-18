//
//  ReviewListingVCTests.swift
//  ReviewsAppTests
//

import XCTest
@testable import ReviewsApp
/*
 Intention is to test the tableview datasource and delegate methods
 */
class ReviewListingVCTests: XCTestCase {
    var reviewVC: ReviewListingVC!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        reviewVC = (storyboard.instantiateViewController(withIdentifier: "ReviewListingVC") as! ReviewListingVC)
        reviewVC.viewModel = ReviewsListingMockViewModel(delegate: reviewVC)
    }

    override func tearDownWithError() throws {
        reviewVC = nil
    }

    func testTableViewDelegates() throws {
        _ = reviewVC.view
        XCTAssert(reviewVC.tableview.numberOfRows(inSection: 0) == 1, "Number of rows not correct")
        XCTAssert(reviewVC.tableview.cellForRow(at: IndexPath(row: 0, section: 0)) is ReviewListingTVCell, "Cell type not correct")
    }
}
