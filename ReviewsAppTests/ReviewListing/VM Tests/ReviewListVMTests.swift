//
//  ReviewListVMTests.swift
//  ReviewsAppTests
//

import XCTest
@testable import ReviewsApp
/*
 Intention is to test the business logic of Reviews App listing page including the fetching and rendering of reviews.
 */
class ReviewListVMTests: XCTestCase {
    var reviewListVM: ReviewListingVM!
    var dataManager: ReviewDataManagerMock!
    var fetchReviewsExpectation: XCTestExpectation!
    var didReceivedResponse = false
    var didReceiveErrorWithCorrectMessage = true
    
    override func setUpWithError() throws {
        dataManager = ReviewDataManagerMock()
        reviewListVM = ReviewListingVM(delegate: self, id: "23776", dataManager: dataManager, managedObjContext: TestCoreDataStack().mockPersistantContainer.viewContext)
        dataManager.delegate = reviewListVM
    }

    override func tearDownWithError() throws {
        dataManager = nil
        reviewListVM = nil
    }

    func testFetchReviewsSuccess() {
        fetchReviewsExpectation = expectation(description: "To test the fetch reviews Async API call success callback")
        didReceivedResponse = false
        reviewListVM.fetchReviews()
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            if !self.didReceivedResponse {
                XCTFail("Expected success delegate to be called")
                return
            }
            XCTAssertTrue(self.didReceivedResponse, "Reviews fetched and success callback received")
        }
    }
    
    func testFetchReviewsError() {
        fetchReviewsExpectation = expectation(description: "To test the fetch reviews Async API call error callback")
        didReceiveErrorWithCorrectMessage = false
        dataManager.shouldTestSuccessFlow = false
        reviewListVM.fetchReviews()
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            if !self.didReceiveErrorWithCorrectMessage {
                XCTFail("Expected error delegate to be called")
                return
            }
            XCTAssertTrue(self.didReceiveErrorWithCorrectMessage, "Reviews fetched and error callback received")
        }
    }
    
    func testTableViewDatasourceMethods() throws{
        fetchReviewsExpectation = expectation(description: "To test the tableview datasource methods in viewmodel")
        didReceivedResponse = false
        reviewListVM.fetchReviews()
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            if !self.didReceivedResponse {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssert(self.reviewListVM.numberOfRows() == 0, "Number of rows not correct")
        }
    }
    
    func testUpdateSort(){
        fetchReviewsExpectation = expectation(description: "To test the Update sort Flow ")
        dataManager.shouldTestSuccessFlow = true
        reviewListVM.updateSort("Most Positive First")
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            if !self.didReceivedResponse {
                XCTFail("Expected success delegate to be called")
                return
            }
            XCTAssertTrue(self.didReceivedResponse, "Reviews fetched and success callback received")
            XCTAssertTrue(self.dataManager.selectedSort?.rawValue == "Most Positive First", "Sort not set correctly")
        }
    }
}

extension ReviewListVMTests: ReviewListVMDelegate{
    func didReceiveResponse(){
        didReceivedResponse = true
        fetchReviewsExpectation.fulfill()
    }
    
    func didFailWithError(_ error: String?){
        didReceiveErrorWithCorrectMessage = true
        fetchReviewsExpectation.fulfill()
    }
    
    func displayFooterView(){

    }
}
