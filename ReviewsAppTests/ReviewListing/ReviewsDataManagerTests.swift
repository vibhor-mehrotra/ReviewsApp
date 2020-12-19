//
//  ReviewsDataManagerTests.swift
//  ReviewsAppTests
//

import XCTest
@testable import ReviewsApp
/*
Intention is to test ReviewsDataManager async operations
 */
class ReviewsDataManagerTests: XCTestCase {
    var dataManager: ReviewsDataManager!
    var fetchReviewsExpectation: XCTestExpectation!
    private let testDBStack = TestCoreDataStack()

    override func setUpWithError() throws {
        dataManager = ReviewsDataManager(id: "23776", networkServices: APIServicesMock(), managedObjContext: testDBStack.mockPersistantContainer.viewContext, archiveChanges: testDBStack.saveContext)
        dataManager.delegate = self
    }

    override func tearDownWithError() throws {
        dataManager = nil
        fetchReviewsExpectation = nil
    }

    func testFetchReviews() throws {
        fetchReviewsExpectation = expectation(description: "To test the fetch reviews Async API call")
        dataManager.fetchReviews(limit: 20, offset: 0, selectedSort: nil)
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            if self.dataManager.reviewData == nil {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertTrue(self.dataManager.reviewData != nil, "Reviews fetched")
        }
    }
    
    func testFinalSort() throws {
        fetchReviewsExpectation = expectation(description: "To test whether sort value sent in API is being correctly marked as selected in CoreData")
        dataManager.fetchReviews(limit: 20, offset: 0, selectedSort: .mostPositiveFirst)
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            guard let selectedSort = self.dataManager.finalSort() else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertTrue(selectedSort == "Most Positive First", "Correct sort value set")
        }
    }
}

extension ReviewsDataManagerTests: ReviewsDMCallbackProtocol{
    func didReceiveData(){
        fetchReviewsExpectation.fulfill()
    }
    
    func didFailWithError(_ error: Error){
        
    }
    
    func allReviewsFetched(){
        
    }
}
