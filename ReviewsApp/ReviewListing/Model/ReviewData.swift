//
//  ReviewsData.swift
//  ReviewsApp
//

import Foundation

struct ReviewsData: Decodable{
    var reviews: [UserReview]?
    var totalCount: Int?
    var pagination: Pagination?
}

struct UserReview: Decodable{
    var id: Int?
    var author: User?
    var title: String?
    var message: String?
    var enjoyment: String?
    var rating: Int16?
    var created: String?
}

struct Pagination: Decodable{
    var limit: Int?
    var offset: Int?
}

struct User: Decodable{
    var fullName: String?
    var country: String?
    var photo: String?
}
