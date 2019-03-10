//
//  MovieCell.swift
//  MovieInfo
//
//  Created by Alfian Losari on 10/03/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    func configure(viewModel: MovieViewViewModel) {
        titleLabel.text = viewModel.title
        overviewLabel.text = viewModel.overview
        releaseDateLabel.text = viewModel.releaseDate
        ratingLabel.text = viewModel.rating
        posterImageView.kf.setImage(with: viewModel.posterURL)
    }
    
}
