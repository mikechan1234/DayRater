//
//  RatingHistoryCollectionViewCellViewModel.swift
//  DayRater
//
//  Created by Michael on 8/9/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import Foundation

struct RatingHistoryCollectionViewCellViewModel: RatingHistoryCellContents {
    
    var datePosted: Date
    var score: Int
    
}

extension RatingHistoryCollectionViewCellViewModel {
    
    init(_ rating: Rating) {
        
        score = Int(rating.score)
        datePosted = rating.dateAdded as Date
        
    }
    
}
