//
//  ReviewListingWireframe.swift
//  ReviewsApp
//

import UIKit

final class ReviewListingWireframe{
    static func reviewListingVC(id: String, name: String) -> ReviewListingVC{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let listVC = (storyboard.instantiateViewController(withIdentifier: "ReviewListingVC") as! ReviewListingVC)
        listVC.title = name
        let dataManager = ReviewsDataManager(id: id)
        let viewModel = ReviewListingVM(delegate: listVC, id: id, dataManager: dataManager)
        dataManager.delegate = viewModel
        listVC.viewModel = viewModel
        return listVC
    }
}
