//
//  RatingComposerStatusView.swift
//  DayRater
//
//  Created by Michael on 15/9/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import UIKit

class RatingComposerStatusView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: 50, height: 50)
        
        collectionView.collectionViewLayout = flowLayout
        collectionView.isPagingEnabled = true
        collectionView.register(UINib(nibName: "RatingComposerStatusCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RatingComposerStatusCollectionViewCell")
        
        textView.text = "How are you doing today?"
        textView.font = UIFont.systemFont(ofSize: 26, weight: .medium)
        
    }

}
