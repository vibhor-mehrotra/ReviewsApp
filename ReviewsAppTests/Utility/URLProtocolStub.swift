//
//  URLProtocolStub.swift
//  ReviewsAppTests
//

import Foundation

enum TestError: Error{
    case badRequest
}

class URLProtocolStub: URLProtocol {
    static var testURLs = [URL?: Data]()
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let url = request.url {
            if let data = URLProtocolStub.testURLs[url] {
                self.client?.urlProtocol(self, didLoad: data)
            } else {
                self.client?.urlProtocol(self, didFailWithError: NSError(domain:"", code:500, userInfo:[ NSLocalizedDescriptionKey: "Bad Request"]))
            }
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
