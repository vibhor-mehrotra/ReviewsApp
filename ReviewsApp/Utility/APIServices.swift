//
//  APIServices.swift
//  ReviewsApp
//
//

import UIKit

enum NetworkError: LocalizedError{
    case invalidURL(message: String)
    case noResponse(message: String)
    case invalidResponse(message: String)
    
    var errorDescription: String?{
        switch self {
        case let .invalidURL(message), let .noResponse(message), let .invalidResponse(message):
            return message
        }
    }
}

protocol APIServicesProtocol{
   func fetchData(for scheme: String, host: String, path: String, callBack: @escaping (Result<Data, NetworkError>) -> Void, queryParams: [String: String], urlSession: URLSession)
}

extension APIServicesProtocol{
    func fetchData(for scheme: String, host: String, path: String, callBack: @escaping (Result<Data, NetworkError>) -> Void, queryParams: [String: String] = [:], urlSession: URLSession = URLSession.shared){
        fetchData(for: scheme, host: host, path: path, callBack: callBack, queryParams: queryParams, urlSession: urlSession)
    }
}

final class APIServices: APIServicesProtocol {
    func fetchData(for scheme: String, host: String, path: String, callBack: @escaping (Result<Data, NetworkError>) -> Void, queryParams: [String: String], urlSession: URLSession) {
        guard let url = constructURL(for: scheme, host: host, path: path, queryParams: queryParams) else{
            callBack(.failure(.invalidURL(message: "Invalid URL")))
            return
        }
        urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
            if let _error = error{
                DispatchQueue.main.async {
                   callBack(.failure(.noResponse(message: _error.localizedDescription)))
                }
            } else {
                if let _data = data{
                    DispatchQueue.main.async {
                        callBack(.success(_data))
                    }
                } else{
                    DispatchQueue.main.async {
                        callBack(.failure(.invalidResponse(message: "Response not in correct format")))
                    }
                }
            }
        }).resume()
    }
    
    private func constructURL(for scheme: String, host: String, path: String, queryParams: [String: String]) -> URL?{
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.setQueryItems(with: queryParams)
        return urlComponents.url
    }
}

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
