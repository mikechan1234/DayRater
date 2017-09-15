//
//  RatingComposerStatusCollectionViewCell.swift
//  DayRater
//
//  Created by Michael on 12/9/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import UIKit

enum RatingComposerStatusState {
    case question
    case negative
    case positive
}

class RatingComposerStatusCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var statusTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override var intrinsicContentSize: CGSize {
        
        return CGSize(width: UIViewNoIntrinsicMetric, height: 100)
        
    }

}

extension RatingComposerStatusCollectionViewCell {
    
    func configure(for state: RatingComposerStatusState) {
        
        switch state {
            
        case .question:
            statusTextLabel.text = "🤔"
            break
            
        case .negative:
            statusTextLabel.text = "😐"
            break
            
        case .positive:
            statusTextLabel.text = "😁"
            break
            
        }
        
    }
    
}
