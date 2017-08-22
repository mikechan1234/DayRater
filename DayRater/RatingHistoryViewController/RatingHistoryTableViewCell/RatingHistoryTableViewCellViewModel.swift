//
//  RatingHistoryTableViewCellViewModel.swift
//  DayRater
//
//  Created by Michael on 22/8/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import Foundation

struct RatingHistoryTableViewCellViewModel: RatingHistoryTableViewCellContents {
    
    var datePosted: Date
    var score: Int
    var scoreDescription: String?
    
}

extension RatingHistoryTableViewCellViewModel {
    
    init(rating: Rating) {
        
        score = Int(rating.score)
        datePosted = rating.dateAdded as Date
        scoreDescription = rating.ratingDescription
        
    }
    
}
