//
//  MoviesAPIConfiguration.swift
//  Movies
//
//  Created by Sumirna Philips on 6/6/17.
//  Copyright © 2017 sumirnat. All rights reserved.
//

import Foundation
class MovieAPIConfiguration {
    static let configurationPath = "/3/configuration"
    
    static var secureBaseImageUrl: String?
    static var posterSizes: [String]?
    
    //MARK: -Class Method: to configure TMDB API for images
    class func configure(_ performAsync: Bool = true, onComplete: @escaping () -> Void) {
        var isComplete = false
        let url = NetworkClient.createUrl(configurationPath, parameter: nil)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: URLRequest(url: url!), completionHandler: {
            (data, response, responseError) in
            if let rawResponseData = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: rawResponseData, options: []) as! Dictionary<String, Any>
                    if let rawImageConfiguration = jsonResponse["images"] {
                        loadImageConfigure(rawImageConfiguration as! [String : Any])
                    }
                    onComplete()
                }
                catch let error as NSError {
                    //JSON parsing error
                    print("\(error.localizedDescription)")
                }
            }
            else {
                print("No Data")
            }
            isComplete = true
        })
        task.resume()
        if(!performAsync) {
            while(!isComplete){}
        }
    }
    
    //MARK: -Class Method: setting the base image URL and to identify the poster image sizes
    class func loadImageConfigure(_ config: [String:Any]) {
        secureBaseImageUrl = config["secure_base_url"] as? String
        posterSizes = config["poster_sizes"] as? [String]
        if let allPosterSize = posterSizes {
            print("Poster sizes: \(allPosterSize)")
        }
    }
}
