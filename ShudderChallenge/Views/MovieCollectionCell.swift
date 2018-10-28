//
//  MovieCollectionCell.swift
//  ShudderChallenge
//
//  Created by Felix Changoo on 10/26/18.
//  Copyright © 2018 Felix Changoo. All rights reserved.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    @IBOutlet weak var imageView: UIImageView!
    var movie: Movie? = nil {
        didSet {
            if let movie = movie {
                imageView.getImageUsingCacheWithURLString(movie.urlString, placeholder: nil, completionHandler: {_ in })
            }
        }
    }
    
    func configure(movie: Movie) {
        self.movie = movie
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        self.layer.shadowRadius = 100
        self.layer.shadowOpacity = 100
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
