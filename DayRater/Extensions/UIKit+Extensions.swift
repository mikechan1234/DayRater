//
//  UIKit+Extensions.swift
//  DayRater
//
//  Created by Michael on 12/9/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import UIKit

extension UIView {
    
    class func viewFor<T: UIView>(nibName: String, using bundle: Bundle = Bundle.main) -> T {
        
        let view = bundle.loadNibNamed(nibName, owner: nil, options: nil)!.last as! T
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
        
    }
    
}


// MARK: - Layout functions

typealias UIViewLayoutOrientation = UICollectionViewScrollDirection

extension UIView {
    
    func layout(views: [UIView], for orientation: UIViewLayoutOrientation, topPadding: CGFloat = 0, bottomPadding: CGFloat = 0, sidePadding: CGFloat = 0, interitemPadding: CGFloat = 0) {
        
        var viewDictionary: [String : UIView] = [:]
        let metricDictionary: [String: CGFloat] = ["topPadding": topPadding, "interitemPadding": interitemPadding, "sidePadding": sidePadding, "bottomPadding": bottomPadding]
        var vflString = orientation == .vertical ? "V:|-topPadding-" : "H:|-topPadding-"
        
        for (index, view) in views.enumerated() {
            
            let viewString = "view\(index)"
            
            viewDictionary[viewString] = view
            vflString.append("[\(viewString)]-")
            if index < views.count - 1 {
                vflString.append("interitemPadding-")
            }
            
            addSubview(view)
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: (orientation == .vertical ? "H:|-sidePadding-" : "V:|-sidePadding-") + "[\(viewString)]-sidePadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricDictionary, views: [viewString : view]))
            
        }
        
        vflString.append("bottomPadding-|")
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vflString, options: NSLayoutFormatOptions(rawValue: 0), metrics: metricDictionary, views: viewDictionary))
        
    }
    
}
