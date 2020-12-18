//
//  APIServicesMock.swift
//  ReviewsAppTests
//

import XCTest
@testable import ReviewsApp

class APIServicesMock: APIServicesProtocol{
     func fetchData(for scheme: String, host: String, path: String, callBack: @escaping (Result<Data, NetworkError>) -> Void, queryParams: [String: String], urlSession: URLSession) {
        callBack(.success(MockData.reviewMockData))
    }
}
