//
//  ReviewDataManagerMock.swift
//  ReviewsAppTests
//

import UIKit
import CoreData
@testable import ReviewsApp

class ReviewDataManagerMock: ReviewsDataManagerProtocol{
    weak var delegate: ReviewsDMCallbackProtocol?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let testDBStack = TestCoreDataStack()
    var shouldTestSuccessFlow = true
    var selectedSort: Sort?
    
    func fetchReviews(limit: Int, offset: Int, selectedSort: Sort?){
        self.selectedSort = selectedSort
        resetStaleDatafromDB()
        if !shouldTestSuccessFlow{
            delegate?.didFailWithError(NetworkError.noResponse(message: "Test Error Flow"))
            return
        }
        let reviewData = ReviewData(context: testDBStack.mockPersistantContainer.viewContext)
        
        let review = Review(context: testDBStack.mockPersistantContainer.viewContext)

        review.title = "test title"
        review.message = "test message"
        review.enjoyment = "test enjoyment"
        review.rating = 5
        review.submittedAt = "5 May, 2020"
        
        let author = Author(context: testDBStack.mockPersistantContainer.viewContext)
        
        author.name = "test name"
        author.photo = "test photo url"
        author.country = "test country"
        review.author = author
        reviewData.addToReviews(review)
        testDBStack.saveContext()
        delegate?.didReceiveData()
    }
    
    private func resetStaleDatafromDB(){
        let fetchRequest: NSFetchRequest<ReviewData> = ReviewData.fetchRequest()
        do {
            let reviews = try testDBStack.mockPersistantContainer.viewContext.fetch(fetchRequest)
            if reviews.count > 0{
                testDBStack.mockPersistantContainer.viewContext.delete(reviews[0])
                testDBStack.saveContext()
            }
        } catch let error as NSError {
            print("Error While Fetching Data From DB: \(error.userInfo)")
        }
    }
    
    func finalSort() -> String?{
        return "Most Positive First"
    }
    
    func resetData(){
        
    }
}
