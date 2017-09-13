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
    var ratingDescription: MutableProperty<String?> = MutableProperty<String?>(nil)
    
    init(coreDataManager: CoreDataManager) {
        
        self.coreDataManager = coreDataManager
        
        ratingValidation = selectedRating.map({ (value) -> Bool in
            
            return value != nil ? true : false
            
        })
        
    }
    
}

// MARK: - Public facing functions
extension RatingComposerViewControllerViewModel {
    
    func saveRating() -> SignalProducer<Bool, NoError> {
        
        let rating = Rating.make(from: coreDataManager!.persistentContainer.viewContext, score: selectedRating.value!, description: ratingDescription.value)
        
        return store(rating, using: coreDataManager!.persistentContainer.viewContext)
        
    }
    
}

// MARK: - Storing to Core Data functions

extension RatingComposerViewControllerViewModel {
    
    fileprivate func store(_ rating: Rating, using context: NSManagedObjectContext) -> SignalProducer<Bool, NoError> {
        
        return SignalProducer<Bool, NoError> { (observer, lifetime) in
            
            do {
                
                try context.save()
                
                observer.send(value: true)
                
            } catch {
                
                print(error as NSError)
                observer.send(value: false)
                
            }
            
            observer.sendCompleted()
            
        }
        
    }
    
}
