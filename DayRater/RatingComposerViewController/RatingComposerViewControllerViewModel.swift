//
//  RatingComposerViewControllerViewModel.swift
//  DayRater
//
//  Created by Michael on 6/9/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import CoreData

import ReactiveSwift
import Result

struct RatingComposerViewControllerViewModel {
    
    weak var coreDataManager: CoreDataManager?
    
    var selectedRating: MutableProperty<Int?> = MutableProperty<Int?>(nil)
    var ratingValidation: Property<Bool>!
    
    init(coreDataManager: CoreDataManager) {
        
        self.coreDataManager = coreDataManager
        
        ratingValidation = selectedRating.map({ (value) -> Bool in
            
            guard value != nil else {
            
                return false
            
            }
            
            return true
            
        })
        
    }
    
}

// MARK: - Public facing functions
extension RatingComposerViewControllerViewModel {
    
    func saveRating() -> SignalProducer<Bool, NoError> {
        
        let rating = Rating.make(from: coreDataManager!.persistentContainer.viewContext, score: selectedRating.value!)
        
        return store(rating, using: coreDataManager!.persistentContainer.viewContext)
        
    }
    
}

extension RatingComposerViewControllerViewModel {
    
    fileprivate func store(_ rating: Rating, using context: NSManagedObjectContext) -> SignalProducer<Bool, NoError> {
        
        return SignalProducer<Bool, NoError> { (observer, lifetime) in
            
            do {
                
                try context.save()
                
                observer.send(value: true)
                
            } catch {
                
                observer.send(value: false)
                
            }
            
            observer.sendCompleted()
            
        }
        
    }
    
}
