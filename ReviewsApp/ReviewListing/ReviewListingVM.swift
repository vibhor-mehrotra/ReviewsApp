//
//  ReviewListingVM.swift
//  ReviewsApp
//

import UIKit
import CoreData

protocol ReviewListVMDelegate: class{
    func didReceiveResponse()
    func didFailWithError(_ error: String?)
    func displayFooterView()
}

//Protocol to mock ReviewListingVM
protocol ReviewListingVMProtocol{
    var selectedSort: String? {get}
    var sorts: [String] {get}
    func fetchReviews()
    func numberOfRows() -> Int
    func dataForRowAt(_ indexPath: IndexPath) -> ReviewListCellViewModel?
    func updateSort(_ sort: String)
}

final class ReviewListingVM: NSObject, ReviewListingVMProtocol{
    var sorts: [String] = Constants.sortOptions
    private var sort: Sort?
    var selectedSort: String?{
        return dataManager.finalSort()
    }
    private var offset = 0
    private let limit = 20
    private var id: String
    weak var delegate: ReviewListVMDelegate?
    var managedObjectContexct = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let dataManager: ReviewsDataManagerProtocol
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Review> = {
        let fetchRequest: NSFetchRequest<Review> = Review.fetchRequest()
        fetchRequest.fetchBatchSize = limit
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContexct, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    init(delegate: ReviewListVMDelegate, id: String, dataManager: ReviewsDataManagerProtocol){
        self.delegate = delegate
        self.id = id
        self.dataManager = dataManager
    }
    
    private func performReviewsFetch(){
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            delegate?.didFailWithError(error.localizedDescription)
        }
    }
    
    func fetchReviews(){
        dataManager.fetchReviews(limit: limit, offset: offset, selectedSort: sort)
    }
    
    func numberOfRows() -> Int{
        return self.fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    func dataForRowAt(_ indexPath: IndexPath) -> ReviewListCellViewModel?{
        if indexPath.row == self.fetchedResultsController.sections![0].numberOfObjects-2{
            //Fetch next batch when second last element approaches
            delegate?.displayFooterView()
            fetchReviews()
        }
        return ReviewListCellViewModel(data: self.fetchedResultsController.object(at: indexPath))
    }
    
    func updateSort(_ sort: String) {
        let newSort = Sort(rawValue: sort)!
        self.sort = newSort == self.sort ? nil : newSort
        offset = 0
        dataManager.resetData()
        fetchReviews()
    }
}

extension ReviewListingVM: ReviewsDMCallbackProtocol{
    func didReceiveData(){
        performReviewsFetch()
        offset += limit
        delegate?.didReceiveResponse()
    }
    
    func didFailWithError(_ error: Error){
        performReviewsFetch()
        guard let sections = self.fetchedResultsController.sections, sections.count > 0, sections[0].numberOfObjects > 0, offset < sections[0].numberOfObjects else {
            delegate?.didFailWithError(error.localizedDescription)
            return
        }
        offset += limit
        delegate?.didReceiveResponse()
    }
    
    func allReviewsFetched(){
        delegate?.didFailWithError(nil)
    }
}
