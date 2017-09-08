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
    
    public var sectionIdentifier: String? {
        
        get {
            
            willAccessValue(forKey: "dateAdded")
            
            let dateComponents = Calendar.current.dateComponents([.month, .year], from: dateAdded)
                        
            didAccessValue(forKey: "dateAdded")
            return "\(dateComponents.year! * 1000 + dateComponents.month!)"
            
        }
        
    }

}

extension Rating {
    
    class func dateSortedFetchRequest() -> NSFetchRequest<Rating> {
        
        let aFetchRequest: NSFetchRequest<Rating> = fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
        
        aFetchRequest.sortDescriptors = [sortDescriptor]
        
        return aFetchRequest
        
    }
    
    class func make(from objectContext: NSManagedObjectContext, score: Int, date: Date = Date(), description: String? = nil) -> Rating {
        
        let rating = Rating(context: objectContext)
        
        rating.dateAdded = date
        rating.ratingDescription = description
        rating.score = Int64(score)
        
        return rating
    }
    
}
