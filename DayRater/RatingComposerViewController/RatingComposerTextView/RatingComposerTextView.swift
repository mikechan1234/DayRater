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
    @IBOutlet fileprivate weak var titleHeightConstraint: NSLayoutConstraint!
    
    var hideTitle: Bool = false {
        
        didSet {
            
            titleHeightConstraint.constant = hideTitle ? 0 : 21
            
        }
        
    }
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = "Comments"
        titleLabel.font = .boldSystemFont(ofSize: 17)
        
        placeholderTextLabel.text = "Add your thoughts here"        
        placeholderTextLabel.font = .systemFont(ofSize: 14, weight: .medium)
        placeholderTextLabel.textColor = .lightGray
        placeholderTextLabel.isUserInteractionEnabled = false
        placeholderTextLabel.reactive.isHidden <~ textView.reactive.continuousTextValues.map { (text) -> Bool in
            
            guard let characterCount = text?.characters.count else {
                
                return false
                
            }
            
            return characterCount > 0
            
        }
        
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
    }
    
}
