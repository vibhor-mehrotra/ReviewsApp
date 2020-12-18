//
//  ReviewListingVMMock.swift
//  ReviewsAppTests
//

import UIKit

@testable import ReviewsApp

class ReviewsListingMockViewModel: ReviewListingVMProtocol{
    weak var delegate: ReviewListVMDelegate?
    var selectedSort: String?
    var sorts: [String]  = ["Most Positive First", "Most Negative First", "Most Latest First"]
    
    init(delegate: ReviewListVMDelegate){
        self.delegate = delegate
    }
    func fetchReviews(){
        delegate?.didReceiveResponse()
    }
    
    func numberOfRows() -> Int{
        return 1
    }
    
    func dataForRowAt(_ indexPath: IndexPath) -> ReviewListCellViewModel?{
        let review = Review(context: TestCoreDataStack().mockPersistantContainer.viewContext)
        return ReviewListCellViewModel(data: review)
    }
    
    func updateSort(_ sort: String){
        selectedSort = sort
    }
}
