//
//  RatingComposerTextView.swift
//  DayRater
//
//  Created by Michael on 12/9/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import UIKit

import ReactiveCocoa
import ReactiveSwift
import Result

class RatingComposerTextView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = "Description"
        
        placeholderTextLabel.textColor = .lightGray
        placeholderTextLabel.isUserInteractionEnabled = false
        
        bindSignals()
        
    }
    
    fileprivate func bindSignals() {
    
        placeholderTextLabel.reactive.isHidden <~ textView.reactive.continuousTextValues.map { (text) -> Bool in
            
            guard let characterCount = text?.characters.count else {
                
                return false
                
            }
            
            return characterCount > 0
            
        }
    
    }
    
}
