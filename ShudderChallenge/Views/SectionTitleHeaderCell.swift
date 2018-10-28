//
//  SectionHeaderCell.swift
//  ShudderChallenge
//
//  Created by Felix Changoo on 10/25/18.
//  Copyright © 2018 Felix Changoo. All rights reserved.
//

import UIKit

class SectionTitleHeaderCell: UITableViewCell {

    
    @IBOutlet weak var sectionLabel: UILabel!
    
    func configure(sectionTitle: String) {
        sectionLabel.text = sectionTitle
    }
}
