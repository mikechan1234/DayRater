//
//  RatingHistoryTableViewCell.swift
//  DayRater
//
//  Created by Michael on 22/8/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import UIKit

protocol RatingHistoryTableViewCellContents {
    
    var datePosted: Date {get set}
    var score: Int {get set}
    var scoreDescription: String? {get set}
    
}

class RatingHistoryTableViewCell: UITableViewCell {
    
    static let identifier: String = "RatingHistoryTableViewCell"

    @IBOutlet weak var scoreTitleLabel: UILabel!
    @IBOutlet weak var scoreValueLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionBottomLabel: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        descriptionBottomLabel.constant = 8
    }
    
}

extension RatingHistoryTableViewCell {
    
    func configure(using content: RatingHistoryTableViewCellContents) {
        
        scoreValueLabel.text = "\(content.score)"
        datePostedLabel.text = content.datePosted.description
        
        if let description = content.scoreDescription {
            
            descriptionLabel.text = description
            
        } else {
            
            descriptionBottomLabel.constant = 0
            descriptionLabel.text = ""
            
            contentView.setNeedsLayout()
            
        }
        
    }
    
}
