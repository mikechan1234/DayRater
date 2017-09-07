//
//  RatingHistoryViewControllerViewModel.swift
//  DayRater
//
//  Created by Michael on 22/8/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import CoreData
import Foundation

import ReactiveSwift
import Result

class RatingHistoryViewControllerViewModel: NSObject {
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<Rating>!
    fileprivate var ratings: [IndexPath : RatingHistoryTableViewCellContents] = [:]
    
    fileprivate unowned var coreDataManager: CoreDataManager
    
    let (willChangeContentSignal, willChangeContentObserver) = Signal<Void, NoError>.pipe()
    let (didChangeContentSignal, didChangeContentObserver) = Signal<Void, NoError>.pipe()
    let (didChangeObjectSignal, didChangeObjectObserver) = Signal<(didChangeObject: Any, atIndexPath: IndexPath?, forType: NSFetchedResultsChangeType, newIndexPath: IndexPath?), NoError>.pipe()
    
    
    init(coreData: CoreDataManager) {
        coreDataManager = coreData
        
        super.init()
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: Rating.dateSortedFetchRequest(), managedObjectContext: coreData.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            
            try fetchedResultsController.performFetch()
            
        } catch {
            
        }
        
    }
    
    deinit {
        
        willChangeContentObserver.sendCompleted()
        didChangeContentObserver.sendCompleted()
        didChangeObjectObserver.sendCompleted()
        
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


// MARK: - ViewModel factory
extension RatingHistoryViewControllerViewModel {
    
    func makeRatingComposerViewModel() -> RatingComposerViewControllerViewModel {
        
        let viewModel = RatingComposerViewControllerViewModel(coreDataManager: coreDataManager)
        
        return viewModel
        
    }
    
}

extension RatingHistoryViewControllerViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        willChangeContentObserver.send(value: ())
    
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        didChangeContentObserver.send(value: ())
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        ratings.removeAll()
        
        didChangeObjectObserver.send(value: (anObject, indexPath, type, newIndexPath))
        
    }
    
}
