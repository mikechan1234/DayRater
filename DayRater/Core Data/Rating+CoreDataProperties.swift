//
//  Rating+CoreDataProperties.swift
//  DayRater
//
//  Created by Michael on 7/9/2017.
//  Copyright © 2017 Michael. All rights reserved.
//
//

import Foundation
import CoreData


extension Rating {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rating> {
        return NSFetchRequest<Rating>(entityName: "Rating")
    }

    @NSManaged public var dateAdded: NSDate
    @NSManaged public var ratingDescription: String?
    @NSManaged public var score: Int64

}
