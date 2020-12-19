//
//  ReviewsDataManager.swift
//  ReviewsApp
//

import UIKit
import CoreData

protocol ReviewsDMCallbackProtocol: class{
    func didReceiveData()
    func didFailWithError(_ error: Error)
    func allReviewsFetched()
}

//Protocol to mock ReviewsDataManager
protocol ReviewsDataManagerProtocol{
    func fetchReviews(limit: Int, offset: Int, selectedSort: Sort?)
    func finalSort() -> String?
    func resetData()
}

final class ReviewsDataManager: ReviewsDataManagerProtocol{
    private let networkServices: APIServicesProtocol
    private let id: String
    private(set) var selectedSort: Sort?
    private(set) var reviewData: ReviewData!
    private var totalCount: Int?
    private let archiveChanges: () -> Void
    private let managedObjectContexct: NSManagedObjectContext
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    weak var delegate: ReviewsDMCallbackProtocol?
    
    private var isFreshRequest = true 
    
    init(id: String, networkServices: APIServicesProtocol = APIServices(), managedObjContext: NSManagedObjectContext, archiveChanges: @escaping () -> Void){
        self.id = id
        self.networkServices = networkServices
        self.managedObjectContexct = managedObjContext
        self.archiveChanges = archiveChanges
    }
    
    func fetchReviews(limit: Int, offset: Int, selectedSort: Sort?){
        if let _totalCount = totalCount, offset >= _totalCount{
            //No need for API call as all the records are already fetched
            delegate?.allReviewsFetched()
        }
        networkServices.fetchData(for: Constants.scheme, host: Constants.host, path: Constants.reviewsURLPath(self.id), callBack: { [weak self](result) in
            switch result{
            case .success(let data):
                do{
                    let data = try JSONDecoder().decode(ReviewsData.self, from: data)
                    self?.selectedSort = selectedSort
                    self?.saveData(data)
                } catch let error{
                    self?.delegate?.didFailWithError(error)
                }
            case .failure(let error):
                self?.delegate?.didFailWithError(error)
            }
        }, queryParams: queryParams(offset: offset, limit: limit, selectedSort: selectedSort))
    }
    
    func resetData(){
        isFreshRequest = true
        reviewData = nil
        totalCount = nil
    }
    
    func finalSort() -> String?{
        if self.reviewData != nil{
            return self.reviewData?.sort
        }
        let fetchRequest: NSFetchRequest<ReviewData> = ReviewData.fetchRequest()
        do {
            let reviews = try managedObjectContexct.fetch(fetchRequest)
            if reviews.count > 0{
                self.reviewData = reviews[0]
            }
        } catch let error as NSError {
            print("Error While Fetching Data From DB: \(error.userInfo)")
        }
        return self.reviewData.sort
    }
    
    private func queryParams(offset: Int, limit: Int, selectedSort: Sort?) -> [String: String]{
        var queryDict = [String: String]()
        queryDict["offset"] = "\(offset == 0 ? 0 : offset+1)"
        queryDict["limit"] = "\(limit)"
        if let _selectedSort = selectedSort{
            queryDict["sort"] = _selectedSort.apiObject()
        }
        return queryDict
    }
}

extension ReviewsDataManager{
    private func resetStaleDatafromDB(){
        let fetchRequest: NSFetchRequest<ReviewData> = ReviewData.fetchRequest()
        do {
            let reviews = try managedObjectContexct.fetch(fetchRequest)
            if reviews.count > 0{
                managedObjectContexct.delete(reviews[0])
                appDelegate.saveContext()
            }
        } catch let error as NSError {
            print("Error While Fetching Data From DB: \(error.userInfo)")
        }
    }
    
    private func saveData(_ reviewData: ReviewsData){
        if isFreshRequest{
            isFreshRequest = false
            resetStaleDatafromDB()
        }
        if self.reviewData != nil{
            addReviews(reviewData.reviews)
        } else {
            self.reviewData = ReviewData(context: managedObjectContexct)
            self.reviewData.totalCount = reviewData.totalCount != nil ? Int32(reviewData.totalCount!) : 0
            self.reviewData.sort = selectedSort?.rawValue
            addReviews(reviewData.reviews)
        }
        appDelegate.saveContext()
        delegate?.didReceiveData()
    }
    
    private func addReviews(_ reviews: [UserReview]?){
        guard let _reviews = reviews, !_reviews.isEmpty else{
            return
        }
        for _review in _reviews{
            let review = Review(context: managedObjectContexct)
            if let authorData = _review.author{
                review.author = createAuthor(authorData)
            }
            review.createdAt = Date()
            review.title = _review.title
            review.message = _review.message
            review.enjoyment = _review.enjoyment
            review.submittedAt = displayDateFrom(_review.created)
            review.rating = _review.rating ?? Int16.max
            self.reviewData.addToReviews(review)
        }
    }
    
    private func displayDateFrom(_ date: String?) -> String?{
        guard let dateStr = date else{
            return nil
        }
        let strToDateDF = DateFormatter()
        strToDateDF.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let dateFromStr = strToDateDF.date(from: dateStr) else {
            return nil
        }
        let dateToStrDF = DateFormatter()
        dateToStrDF.dateFormat = "MMM d, yyyy"
        return dateToStrDF.string(from: dateFromStr)
    }
    
    private func createAuthor(_ data: User) -> Author{
        let author = Author(context: managedObjectContexct)
        author.name = data.fullName
        author.photo = data.photo
        author.country = data.country
        return author
    }
}
