//
//  RatingHistoryViewControllerViewModel.swift
//  DayRater
//
//  Created by Michael on 22/8/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import CoreData
import Foundation

class RatingHistoryViewControllerViewModel: NSObject {
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<Rating>!
    
    weak var coreDataManager: CoreDataManager?
    
    init(coreData: CoreDataManager) {
        super.init()
        coreDataManager = coreData
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: Rating.fetchRequest(), managedObjectContext: coreData.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            
            try fetchedResultsController.performFetch()
            
        } catch {
            
        }
        
    }
    
}

extension RatingHistoryViewControllerViewModel: NSFetchedResultsControllerDelegate {
    
    
}
