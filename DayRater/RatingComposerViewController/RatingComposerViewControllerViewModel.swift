//
//  RatingComposerViewControllerViewModel.swift
//  DayRater
//
//  Created by Michael on 6/9/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import ReactiveSwift
import Result

struct RatingComposerViewControllerViewModel {
    
    unowned var coreDataManager: CoreDataManager
    
    var selectedRating: MutableProperty<Int?> = MutableProperty<Int?>(nil)
    var selectedRatingSignal: SignalProducer<Bool, NoError>!
    
    init(coreDataManager: CoreDataManager) {
        
        self.coreDataManager = coreDataManager
        
        selectedRatingSignal = selectedRating.producer.map({ (value) -> Bool in
            
            return value != nil ? true : false
            
        })
        
    }
    
}

extension RatingComposerViewControllerViewModel {
    
    func saveRating() -> SignalProducer<Void, NoError> {
        
        return SignalProducer.empty
        
    }
    
}
