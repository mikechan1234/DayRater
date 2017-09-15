//
//  RatingComposerInputAccessoryView.swift
//  DayRater
//
//  Created by Michael on 15/9/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import UIKit

class RatingComposerInputAccessoryView: UIView {
    
    @IBOutlet weak var negativeButton: UIButton!
    @IBOutlet weak var positiveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        negativeButton.layer.cornerRadius = 3
        negativeButton.layer.masksToBounds = true
        
        positiveButton.layer.cornerRadius = 3
        positiveButton.layer.masksToBounds = true
        
        
    }
    
    override var intrinsicContentSize: CGSize {
        
        return CGSize(width: UIViewNoIntrinsicMetric, height: 44)
        
    }

}
