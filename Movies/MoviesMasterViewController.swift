//
//  MoviesMasterViewController.swift
//  Movies
//
//  Created by Sumirna Philips on 6/6/17.
//  Copyright © 2017 sumirnat. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking
import MBProgressHUD

class MoviesMasterViewController:UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var movieTableView: UITableView!
    var allMovies = [Movie]()
    var searchText:String?
    var filteredMovies = [Movie]()
    var pageCount: Int?
    var totalPages: Int?
    var lastFetch = 0
    var allMoviesFetched = false
    var isFetchingdata = false
    var moviePath:String = "/3/search/movie"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup the Search Controller
        
    }
    
    //MARK: - Textfield delegate methods
    func textFieldDidEndEditing(_ textField: UITextField) {
        filteredMovies.removeAll()
        movieTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if(textField.text != ""){
            self.searchText =  textField.text
            fetchMovieData() // fetching movies based on the search text from the server
        }
        return true
        
    }
    
    //MARK: - fetch movies by sending the search text and page number
    
    func fetchMovieData(){
        
        if allMoviesFetched || isFetchingdata {
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if let page = pageCount {
            if let totalPages = totalPages {
                if page < totalPages {
                    self.pageCount = page + 1
                }
                else {
                    allMoviesFetched = true
                }
            }
        }
        isFetchingdata = true
        let myCompletionHandler: (Data?, URLResponse?, Error?) -> Void = {
            (data, response, error) in
            self.onFetchMoviesComplete(data, response: response, error: error)
        }
        Movie.searchMoviesRequest(moviePath, searchString: searchText, page: pageCount, onComplete: myCompletionHandler)
    }
    
    //MARK: - completion handler method - converts the rawResponseData into movies objects
    
    func onFetchMoviesComplete(_ data: Data?, response: URLResponse?, error: Error?) {
        isFetchingdata = false
        if error != nil {
            // Handling HTTP TMDB API request error
            print("\(String(describing: error?.localizedDescription))")
        }
        else {
            if let rawResponseData = data {
                do {
                    let jsonDictionary = try JSONSerialization.jsonObject(with: rawResponseData, options: []) as! Dictionary<String, Any>
                    self.pageCount = jsonDictionary["page"] as? Int
                    self.totalPages = jsonDictionary["total_pages"] as? Int
                    
                    if let moviesDictionary = jsonDictionary["results"] as? [[String: AnyObject]] {
                        for movie in moviesDictionary {
                            self.filteredMovies.append(Movie(jsonParser: movie))
                        }
                        self.allMovies = filteredMovies
                    }
                }
                catch let error as NSError {
                    // Handling JSON parsing error
                    print("\(error.localizedDescription)")
                }
            }
        }
        lastFetch = self.allMovies.count - 1
        // Refreshing movies table view in the main thread
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.movieTableView.reloadData()
            if(self.filteredMovies.count==0){
                let alert = UIAlertController(title: "Alert", message: "Movies not found!!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    //MARK: - TableView delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let moviesCount = self.filteredMovies.count
        if(moviesCount==0){
            tableView.isHidden = true
            messageLabel.isHidden = false
        }
        else{
            tableView.isHidden = false
            messageLabel.isHidden = true
        }
        return moviesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MoviesCustomTableViewCell
        let movie = filteredMovies[indexPath.row]
        cell.movieTitle.text = movie.title
        if let posterImageUrl = movie.posterImageUrl() {
            cell.movieImage.setImageWith(posterImageUrl)
        }
        if(indexPath.row >= lastFetch && !allMoviesFetched){
            fetchMovieData()
        }
        return cell
    }
    
    //MARK: - prepare segue to create and push to MoviesDetailViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetails" {
            if let movieDetailViewController = segue.destination as? MoviesDetailViewController {
                if let indexPath = movieTableView.indexPathForSelectedRow {
                    movieDetailViewController.movieDetail = allMovies[indexPath.row]
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


