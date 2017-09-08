//
//  RatingHistoryCollectionViewCell.swift
//  DayRater
//
//  Created by Michael on 8/9/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import UIKit

protocol RatingHistoryCellContents {
    
    var datePosted: Date {get set}
    var score: Int {get set}
    
}

class RatingHistoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
    }

}

extension RatingHistoryCollectionViewCell {
    
    func configure(using content: RatingHistoryCellContents) {
        
        scoreLabel.text = content.score == 0 ? "👎" : "👍"
        dateLabel.text = content.datePosted.description
        
    }
    
}
