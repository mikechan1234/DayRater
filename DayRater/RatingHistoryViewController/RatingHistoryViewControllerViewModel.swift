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
    fileprivate var ratings: [IndexPath : RatingHistoryCellContents] = [:]
    
    fileprivate var currentCalendar: Calendar
    fileprivate unowned var coreDataManager: CoreDataManager
    
    let (didChangeObjectSignal, didChangeObjectObserver) = Signal<(didChangeObject: Any, atIndexPath: IndexPath?, forType: NSFetchedResultsChangeType, newIndexPath: IndexPath?), NoError>.pipe()
    let (didChangeSectionInfoSignal, didChangeSectionInfoObserver) = Signal<(sectionInfo: NSFetchedResultsSectionInfo, atIndex: Int, forType: NSFetchedResultsChangeType), NoError>.pipe()
    
    
    init(coreData: CoreDataManager, calendar: Calendar = Calendar.current) {
        coreDataManager = coreData
        currentCalendar = calendar
        
        super.init()
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: Rating.dateSortedFetchRequest(), managedObjectContext: coreData.persistentContainer.viewContext, sectionNameKeyPath: "sectionIdentifier", cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            
            try fetchedResultsController.performFetch()
            
        } catch {
            
        }
        
    }
    
    deinit {
        
        didChangeObjectObserver.sendCompleted()
        didChangeSectionInfoObserver.sendCompleted()
        
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
    
    func cellContents(for indexPath: IndexPath) -> RatingHistoryCellContents {
        
        if let viewModel = ratings[indexPath] {
            
            return viewModel
            
        } else {
            
            let rating = fetchedResultsController.object(at: indexPath)
            let viewModel = RatingHistoryCollectionViewCellViewModel(rating)
            
            ratings[indexPath] = viewModel
            
            return viewModel
            
        }
        
    }
    
    func sectionTitle(for section: Int) -> String? {
                
        if let title = fetchedResultsController.sections?[section].name, let numericSectionValue = Int(title) {
            
            let year = numericSectionValue / 1000
            let month = numericSectionValue - (year * 1000)
            
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            
            if let date = currentCalendar.date(from: dateComponents) {
                
                return DateFormatter.monthYearFormatter().string(from: date)
                
            }
            
            return nil
        
        }
        
        return nil
            
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
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        ratings.removeAll()
        
        didChangeObjectObserver.send(value: (anObject, indexPath, type, newIndexPath))
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        ratings.removeAll()
        
        didChangeSectionInfoObserver.send(value: (sectionInfo, sectionIndex, type))
        
    }
    
}
