//
//  RatingComposerSelectorView.swift
//  DayRater
//
//  Created by Michael on 12/9/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import UIKit

class RatingComposerSelectorView: UIView {

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var negativeButton: UIButton!
    @IBOutlet weak var positiveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        negativeButton.setTitle("👎", for: .normal)
        positiveButton.setTitle("👍", for: .normal)
        
    }
    
    override var intrinsicContentSize: CGSize {
        
        return CGSize(width: UIViewNoIntrinsicMetric, height: 50)
        
    }

}
