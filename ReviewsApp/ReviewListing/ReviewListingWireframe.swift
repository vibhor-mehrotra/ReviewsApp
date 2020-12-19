//
//  ReviewListingWireframe.swift
//  ReviewsApp
//

import UIKit

final class ReviewListingWireframe{
    static func reviewListingVC(id: String, name: String) -> ReviewListingVC{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let listVC = (storyboard.instantiateViewController(withIdentifier: "ReviewListingVC") as! ReviewListingVC)
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        listVC.title = name
        let dataManager = ReviewsDataManager(id: id, managedObjContext: appDelegate.persistentContainer.viewContext, archiveChanges: appDelegate.saveContext)
        let viewModel = ReviewListingVM(delegate: listVC, id: id, dataManager: dataManager,  managedObjContext: appDelegate.persistentContainer.viewContext)
        dataManager.delegate = viewModel
        listVC.viewModel = viewModel
        return listVC
    }
}
