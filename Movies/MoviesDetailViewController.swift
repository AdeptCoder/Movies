//
//  MoviesDetailViewController.swift
//  Movies
//
//  Created by Sumirna Philips on 6/6/17.
//  Copyright © 2017 sumirnat. All rights reserved.
//

import Foundation
import UIKit

class MoviesDetailViewController: UIViewController{
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var score: UILabel!
    var movieDetail: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assigning the poster image, release date and rating score of the movie to get displayed
        if let selectedMovie = movieDetail {
            if let posterUrl = selectedMovie.posterImageUrl("original") {
                movieImageView.setImageWith(posterUrl)
            }
            movieDescription.text = selectedMovie.overview
            releaseDate.text = selectedMovie.releaseDateFormatted()
            releaseDate.font = UIFont.boldSystemFont(ofSize: releaseDate.font.pointSize)
            score.text = selectedMovie.scoreReader()
            score.font = UIFont.boldSystemFont(ofSize: score.font.pointSize)
            self.title  = selectedMovie.title
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
