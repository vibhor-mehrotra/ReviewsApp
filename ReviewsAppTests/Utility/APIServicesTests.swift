//
//  APIServicesTests.swift
//  ReviewsAppTests
//

import XCTest
@testable import ReviewsApp

class APIServicesTests: XCTestCase {
    var apiServices: APIServicesProtocol!
    var mockURLSession: URLSession!
    
    //MARK: Constants
    let correctURL = "https://www.test.com/reviewURL/?"
    
    override func setUp() {
        apiServices = APIServices()
        URLProtocolStub.testURLs = [URL(string: correctURL): MockData.reviewMockData]
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        mockURLSession = URLSession(configuration: config)
    }

    override func tearDown() {
        apiServices = nil
        mockURLSession = nil
    }
    
    func testAPIServicesSuccess() {
        let successExpectation = expectation(description: "APISuccess success expectation")
        
        apiServices.fetchData(for: "https", host: "www.test.com", path: "/reviewURL/", callBack: { result in
            switch result{
            case .success(let data):
                XCTAssertTrue(!data.isEmpty, "Empty response")
                successExpectation.fulfill()
            case .failure(_):
                XCTFail("APISuccess success case failed")
                successExpectation.fulfill()
            }
        }, queryParams: [:], urlSession: mockURLSession)
        
        wait(for: [successExpectation], timeout: 1.0)
    }
    
    func testAPISuccessFailureWithInvalidID() {
        let invalidIDFailureExpectation = expectation(description: "APISuccess invalid ID failure expectation")
        apiServices.fetchData(for: "https", host: "www.test.com", path: "/badURL/", callBack: { result in
            switch result{
            case .success(_):
                XCTFail("APISuccess failuer test failed")
                invalidIDFailureExpectation.fulfill()
            case .failure(let error):
                switch error{
                case .invalidResponse(_):
                    XCTFail("wrong error type")
                    invalidIDFailureExpectation.fulfill()
                case .invalidURL(_):
                    XCTFail("wrong error type")
                    invalidIDFailureExpectation.fulfill()
                case .noResponse(_):
                    XCTAssertTrue(true)
                    invalidIDFailureExpectation.fulfill()
                }
            }
        }, queryParams: [:], urlSession: mockURLSession)
        
        wait(for: [invalidIDFailureExpectation], timeout: 1.0)
    }
    
    func testAPISuccessFailureWithInvalidURL() {
        let invalidURLFailureExpectation = expectation(description: "APISuccess invalid URL failure expectation")
        
        apiServices.fetchData(for: "https", host: "www.test.com", path: "badURLWithoutSlashes", callBack: { result in
            switch result{
            case .success(_):
                XCTFail("APISuccess bad url failure test failed")
                invalidURLFailureExpectation.fulfill()
            case .failure(let error):
                switch error{
                case .invalidResponse(_):
                   XCTFail("wrong error type")
                    invalidURLFailureExpectation.fulfill()
                case .invalidURL(_):
                   XCTAssertTrue(true)
                    invalidURLFailureExpectation.fulfill()
                case .noResponse(_):
                   XCTFail("wrong error type")
                   invalidURLFailureExpectation.fulfill()
                }
            }
        }, queryParams: [:], urlSession: mockURLSession)
        
        wait(for: [invalidURLFailureExpectation], timeout: 1.0)
    }
}
