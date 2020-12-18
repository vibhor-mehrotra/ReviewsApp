//
//  ReviewListCellViewModel.swift
//  ReviewsApp
//

import UIKit

struct ReviewListCellViewModel{
    var title: String?
    var subtitle: String?
    var userImage: String?
    var userName: String?
    var userCountry: String?
    var ratingText: String?
    var submittedAt: String?
    var ratingViewColor: UIColor
    
    init(data: Review){
        title = data.title
        userImage = data.author?.photo
        userName = data.author?.name
        userCountry = data.author?.country
        if let message = data.message, !message.isEmpty{
            subtitle = message
        } else {
            subtitle = data.enjoyment
        }
        submittedAt = data.submittedAt
        ratingText = String(data.rating)
        ratingViewColor = Constants.bgColorFor(rating: data.rating)
    }
}
