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
    fileprivate var ratings: [IndexPath : RatingHistoryTableViewCellContents] = [:]
    
    weak var coreDataManager: CoreDataManager?
    
    init(coreData: CoreDataManager) {
        super.init()
        coreDataManager = coreData
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: Rating.dateSortedFetchRequest(), managedObjectContext: coreData.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            
            try fetchedResultsController.performFetch()
            
        } catch {
            
        }
        
    }
    
}


// MARK: - Table View functions
extension RatingHistoryViewControllerViewModel {
    
    func numberOfSections() -> Int {
        
        return fetchedResultsController.sections?.count ?? 0
        
    }
    
    func numberOfItems(for section: Int) -> Int {
        
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
        
    }
    
    func cellContents(for indexPath: IndexPath) -> RatingHistoryTableViewCellContents {
        
        if let viewModel = ratings[indexPath] {
            
            return viewModel
            
        } else {
            
            let rating = fetchedResultsController.object(at: indexPath)
            let viewModel = RatingHistoryTableViewCellViewModel(rating: rating)
            
            ratings[indexPath] = viewModel
            
            return viewModel
            
        }
        
    }
    
}

extension RatingHistoryViewControllerViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        
    }
    
}
