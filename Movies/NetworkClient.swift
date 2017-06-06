//
//  NetworkClient.swift
//  Movies
//
//  Created by Sumirna Philips on 6/6/17.
//  Copyright © 2017 sumirnat. All rights reserved.
//

import Foundation

class NetworkClient {
    static let httpScheme = "https"
    static let hostString = "api.themoviedb.org"
    static let apiKeyParameter = "api_key"
    static var apiKeyValue: String?
    
    
    //MARK: -Class Method - to create the url
    class func createUrl(_ searchPath: String, parameter: [URLQueryItem]?) -> URL? {
        var urlComponent = URLComponents()
        urlComponent.scheme = httpScheme
        urlComponent.host = hostString
        urlComponent.path = searchPath
        urlComponent.queryItems = [apiKeyQuery()]
        if let parameter = parameter {
            urlComponent.queryItems?.append(contentsOf: parameter)
        }
        return urlComponent.url
    }
    
    //MARK: -Class Method - to create the api key as a key value pair to append to the url
    class func apiKeyQuery() -> URLQueryItem {
        return URLQueryItem(name: apiKeyParameter, value: apiKeyValue!)
    }
    
    //MARK: -Class Method - to check the URL
    class func urlRequestMade(_ url: URL) {
        print("Request made to: \(url)")
    }
}


