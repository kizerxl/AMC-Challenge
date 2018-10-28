//
//  ViewController.swift
//  ShudderChallenge
//
//  Created by Felix Changoo on 10/24/18.
//  Copyright © 2018 Felix Changoo. All rights reserved.
//

import UIKit

class FeaturedVC: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var navigationArea: DesignableView!
    @IBOutlet weak var tableView: UITableView!
    var movieManager = MovieManager.sharedInstance
    var blurEffect: UIBlurEffect!
    var blurEffectView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "SectionTitleHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "SectionTitleHeader")
        
        blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y / 50
        
        let blurEffectIsPresent = navigationArea.subviews.contains(blurEffectView)
        
        if offset > 1 {
            if !blurEffectIsPresent {
                blurEffectView.frame = navigationArea.frame
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                blurEffectView.backgroundColor = UIColor.clear
                blurEffectView.alpha = 0.3
                blurEffectView.clipsToBounds = true
                
                navigationArea.insertSubview(blurEffectView, at: 0)
            }
        } else {
            if blurEffectIsPresent {
                blurEffectView.removeFromSuperview()
            }
        }
    }
}

extension FeaturedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = movieManager.movieTypes[section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTitleHeaderCell") as! SectionTitleHeaderCell
        cell.configure(sectionTitle: title)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return movieManager.movieTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieRowCell", for: indexPath) as! MovieRowCell
        let sectionIdx = indexPath.section
        let section = movieManager.movieTypes[sectionIdx]
        let spinner = cell.displaySpinner(onView: cell)
        
        movieManager.getMovies(movieSection: section) { [weak self] result in
            guard let strongSelf = self else {
                cell.removeSpinner(spinner: spinner)
                return
            }
            
            DispatchQueue.main.async {
                cell.removeSpinner(spinner: spinner)
                switch result {
                    case .Error(let error):
                        print("Error: \(error.description)")
                        break
                    case .Success(let movies):
                        cell.configure(movies: movies)
                        break
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        else {
            return 1 //we need just one cell per section
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
