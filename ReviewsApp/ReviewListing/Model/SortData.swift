//
//  SortData.swift
//  ReviewsApp
//

import Foundation

enum Sort: String{
    case mostPositiveFirst = "Most Positive First"
    case mostNegativeFirst = "Most Negative First"
    case mostLatestFirst = "Most Latest First"
    
    func apiObject() -> String{
        switch self {
        case .mostPositiveFirst:
            return "rating:desc"
        case .mostNegativeFirst:
            return "rating:asc"
        case .mostLatestFirst:
            return "date:desc"
        }
    }
}
