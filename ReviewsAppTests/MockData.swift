//
//  MockData.swift
//  ReviewsAppTests
//

import UIKit
@testable import ReviewsApp

final class MockData {
    static var reviewMockData: Data{
        return getData(name: "ReviewMockData")
    }
    
    static var reviewMockModel: ReviewsData?{
        get{
            do{
                let data = try JSONDecoder().decode(ReviewsData.self, from: MockData.reviewMockData)
                return data
            } catch {
                return nil
            }
        }
    }
}

extension MockData{
    static func getData(name: String, withExtension: String = "json") -> Data {
        let bundle = Bundle(for: MockData.self)
        let fileUrl = bundle.url(forResource: name, withExtension: withExtension)
        let data = try! Data(contentsOf: fileUrl!)
        return data
    }
}
