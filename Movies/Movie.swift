//
//  Movie.swift
//  Movies
//
//  Created by Sumirna Philips on 6/6/17.
//  Copyright © 2017 sumirnat. All rights reserved.
//

import Foundation

class Movie {
    
    var overview: String?
    var posterPath: String?
    var votesAvg: Double?
    var title: String?
    var releaseDate: Date?
    
    init(jsonParser: [String: AnyObject]) {
        if let overview = jsonParser["overview"] as? String {
            self.overview = overview
        }
        
        if let posterPath = jsonParser["poster_path"] as? String {
            self.posterPath = posterPath
        }
        if let votesAvg = jsonParser["vote_average"] as? Double {
            self.votesAvg = votesAvg
        }
        
        if let title = jsonParser["title"] as? String {
            self.title = title
        }
        
        if let releaseDate = jsonParser["release_date"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.releaseDate = dateFormatter.date(from: releaseDate)
        }
    }
    //formatting date to the format Mon dd,yyyy from yyyy-MM-dd
    func releaseDateFormatted() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        var dateString: String?
        if let releaseDate = self.releaseDate {
            dateString = dateFormatter.string(from: releaseDate)
        }
        return dateString
    }
    //formatting score to a double value with one decimal point
    func scoreReader() -> String? {
        var scoreValue: String?
        if let score = votesAvg {
            scoreValue = String(format: "%.1f", score)
        }
        return scoreValue
    }
    //fetch poster image url
    func posterImageUrl(_ size: String = "w154") -> URL? {
        if let posterPathRaw = posterPath {
            let url = "\(MovieAPIConfiguration.secureBaseImageUrl!)\(size)\(posterPathRaw)"
            if var urlComponent = URLComponents(string: url) {
                urlComponent.queryItems = [NetworkClient.apiKeyQuery()]
                return urlComponent.url
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    // MARK: - Class Method to create the url and make the api search request
    
    class func searchMoviesRequest(_ path: String, searchString:String?, page: Int?, onComplete: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var queryParams = [URLQueryItem]()
        
        if let searchString = searchString  {
            queryParams.append(URLQueryItem(name: "query", value: "\(searchString)"))
        }
        if let page = page {
            queryParams.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        let url = NetworkClient.createUrl("\(path)", parameter: queryParams)!
        NetworkClient.urlRequestMade(url)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: URLRequest(url: url), completionHandler: onComplete)
        task.resume()
    }
    
}
