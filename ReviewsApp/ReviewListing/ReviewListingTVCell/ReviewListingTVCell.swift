//
//  ReviewListingTVCell.swift
//  ReviewsApp
//

import UIKit

final class ReviewListingTVCell: UITableViewCell {
    @IBOutlet weak private var userImg: UIImageView!
    @IBOutlet weak private var userName: UILabel!
    @IBOutlet weak private var userCountry: UILabel!
    @IBOutlet weak private var reviewTitle: UILabel!
    @IBOutlet weak private var reviewDesc: UILabel!
    @IBOutlet weak private var rating: UILabel!
    @IBOutlet weak private var submittedAt: UILabel!
    @IBOutlet weak private var ratingView: UIView!
    
    private let placeholder = UIImage(named: "userPlaceholder")
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImg.image = nil
        userName.text = nil
        userCountry.text = nil
        reviewTitle.text = nil
        reviewDesc.text = nil
        rating.text = nil
        submittedAt.text = nil
        ratingView.backgroundColor = UIColor.clear
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        userImg.layer.cornerRadius = 20.0
        ratingView.layer.cornerRadius = 4.0
    }
    
    func configureCell(_ data: ReviewListCellViewModel){
        self.userImg.fetchImage(data.userImage, placeHolder: placeholder)
        self.userName.text = data.userName
        self.userCountry.text = data.userCountry
        self.reviewTitle.text = data.title
        self.reviewDesc.text = data.subtitle
        self.rating.text = data.ratingText
        self.submittedAt.text = data.submittedAt
        self.ratingView.backgroundColor = data.ratingViewColor
    }
}
