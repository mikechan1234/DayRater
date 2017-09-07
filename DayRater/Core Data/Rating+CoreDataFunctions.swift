//
//  Rating+CoreDataFunctions.swift
//  DayRater
//
//  Created by Michael on 22/8/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import CoreData
import Foundation

extension Rating {
    
    class func dateSortedFetchRequest() -> NSFetchRequest<Rating> {
        
        let aFetchRequest: NSFetchRequest<Rating> = fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: true)
        
        aFetchRequest.sortDescriptors = [sortDescriptor]
        
        return aFetchRequest
        
    }
    
    class func make(from objectContext: NSManagedObjectContext, score: Int, date: Date = Date(), description: String? = nil) -> Rating {
        
        let rating = Rating(context: objectContext)
        
        rating.dateAdded = date as NSDate
        rating.ratingDescription = description
        rating.score = Int64(score)
        
        return rating
    }
    
}
