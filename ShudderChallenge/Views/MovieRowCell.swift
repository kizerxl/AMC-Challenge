//
//  MovieRowCell.swift
//  ShudderChallenge
//
//  Created by Felix Changoo on 10/26/18.
//  Copyright © 2018 Felix Changoo. All rights reserved.
//

import UIKit

class MovieRowCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var movies = [Movie]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    func configure(movies: [Movie]) {
        self.movies = movies
    }
}

extension MovieRowCell:  UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionCell", for: indexPath) as! MovieCollectionCell
        let movie = movies[indexPath.row]
        
        cell.configure(movie: movie)
        return cell
    }
}

extension MovieRowCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let hardCodedPadding:CGFloat = 5
        let itemWidth = CGFloat(90)
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
