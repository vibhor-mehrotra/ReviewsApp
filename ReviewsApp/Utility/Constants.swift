//
//  Constants.swift
//  ReviewsApp
//
//

import UIKit

struct Constants {
    //MARK: URL Params
    static let scheme = "https"
    static let host = "travelers-api.getyourguide.com"
    
    //MARK:- Error Messages
    static let errorTitle = "Error"
    static let defaultErrorMessage = "Something went wrong. Please try again."
    static let firstBtnTitle = "OK"
    
    //MARK:- URL path
    static func reviewsURLPath(_ id: String) -> String{
        return "/activities/\(id)/reviews"
    }
    
    //MARK: - Sort Options
    static let sortOptions = ["Most Positive First", "Most Negative First", "Most Latest First"]
}

//MARK: -
extension Constants{
    static func bgColorFor(rating: Int16) -> UIColor{
        switch rating {
        case 0...2:
           return UIColor(red: 245.0/255.0, green: 88.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        case 3:
            return UIColor(red: 228.0/255.0, green: 245.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        case 4...5:
            return UIColor(red: 46.0/255.0, green: 161.0/255.0, blue: 32.0/255.0, alpha: 1.0)
        default:
            return UIColor.gray
        }
    }
}
