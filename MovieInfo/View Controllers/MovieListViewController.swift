//
//  MovieListViewController.swift
//  MovieInfo
//
//  Created by Alfian Losari on 10/03/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import UIKit
import Kingfisher

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var infoLabel: UILabel!
    
    let dateFormatter: DateFormatter = {
        $0.dateStyle = .medium
        $0.timeStyle = .none
        return $0
    }(DateFormatter())
    
    let movieService: MovieService = MovieStore.shared
    var movies = [Movie]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var endpoint = Endpoint.nowPlaying {
        didSet {
            fetchMovies()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchMovies()
    }
    
    private func fetchMovies() {
        self.movies = []
        activityIndicatorView.startAnimating()
        infoLabel.isHidden = true
        
        movieService.fetchMovies(from: endpoint, params: nil, successHandler: {[unowned self] (response) in
            self.activityIndicatorView.stopAnimating()
            self.movies = response.results
        }) { [unowned self] (error) in
            self.activityIndicatorView.stopAnimating()
            self.infoLabel.text = error.localizedDescription
            self.infoLabel.isHidden = false
        }
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        endpoint = sender.endpoint
    }
}

extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        
        
        cell.titleLabel.text = movie.title
        cell.releaseDateLabel.text = dateFormatter.string(from: movie.releaseDate)
        cell.overviewLabel.text = movie.overview
        cell.posterImageView.kf.setImage(with: movie.posterURL)
        
        let rating = Int(movie.voteAverage)
        let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "⭐️"
        }
        cell.ratingLabel.text = ratingText

        return cell
    }
}

fileprivate extension UISegmentedControl {
    
    var endpoint: Endpoint {
        switch self.selectedSegmentIndex {
        case 0: return .nowPlaying
        case 1: return .popular
        case 2: return .upcoming
        default: fatalError()
        }
    }
}
