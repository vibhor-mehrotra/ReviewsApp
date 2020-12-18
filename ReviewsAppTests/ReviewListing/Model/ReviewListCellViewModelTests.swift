//
//  ReviewListCellViewModelTests.swift
//  ReviewsAppTests
//

import XCTest
import CoreData
@testable import ReviewsApp

/*
Intention is to test whether UItableViewCell viewmodel properties are correctly set from CoreData Review entity
 */
class ReviewListCellViewModelTests: XCTestCase {
    var cellViewModel: ReviewListCellViewModel!
    
    override func setUpWithError() throws {
        let viewContext = TestCoreDataStack().mockPersistantContainer.viewContext
        
        let review = Review(entity: NSEntityDescription.entity(forEntityName: "Review", in: viewContext)!, insertInto: viewContext)

        review.title = "test title"
        review.message = "test message"
        review.enjoyment = "test enjoyment"
        review.rating = 5
        review.submittedAt = "5 May, 2020"
        
        let author = Author(entity: NSEntityDescription.entity(forEntityName: "Author", in: viewContext)!, insertInto: viewContext)
        author.name = "test name"
        author.photo = "test photo url"
        author.country = "test country"
        review.author = author
        cellViewModel = ReviewListCellViewModel(data: review)
    }

    override func tearDownWithError() throws {
        cellViewModel = nil
    }
    
    func testlistCellViewModel(){
        XCTAssert(cellViewModel.title == "test title", "ViewModel title not set correctly")
        XCTAssert(cellViewModel.subtitle == "test message", "ViewModel subtitle not set correctly")
        XCTAssert(cellViewModel.ratingText == "5", "ViewModel rating not set correctly")
        XCTAssert(cellViewModel.submittedAt == "5 May, 2020", "ViewModel submittedAt not set correctly")
        XCTAssert(cellViewModel.userName == "test name", "ViewModel name not set correctly")
        XCTAssert(cellViewModel.userImage == "test photo url", "ViewModel photo url not set correctly")
        XCTAssert(cellViewModel.userCountry == "test country", "ViewModel test country not set correctly")
    }
}
