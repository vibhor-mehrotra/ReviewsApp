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
    let viewContext = TestCoreDataStack().mockPersistantContainer.viewContext
    var shouldTestSuccessFlow = true
    var selectedSort: Sort?
    
    func fetchReviews(limit: Int, offset: Int, selectedSort: Sort?){
        self.selectedSort = selectedSort
        resetStaleDatafromDB()
        if !shouldTestSuccessFlow{
            delegate?.didFailWithError(NetworkError.noResponse(message: "Test Error Flow"))
            return
        }
        let reviewData = ReviewData(context: viewContext)
        
        let review = Review(context: viewContext)

        review.title = "test title"
        review.message = "test message"
        review.enjoyment = "test enjoyment"
        review.rating = 5
        review.submittedAt = "5 May, 2020"
        
        let author = Author(context: viewContext)
        
        author.name = "test name"
        author.photo = "test photo url"
        author.country = "test country"
        review.author = author
        reviewData.addToReviews(review)
        saveContext()
        delegate?.didReceiveData()
    }
    
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func resetStaleDatafromDB(){
        let fetchRequest: NSFetchRequest<ReviewData> = ReviewData.fetchRequest()
        do {
            let reviews = try viewContext.fetch(fetchRequest)
            if reviews.count > 0{
                viewContext.delete(reviews[0])
                saveContext()
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
