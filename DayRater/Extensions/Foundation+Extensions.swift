//
//  Foundation+Extensions.swift
//  DayRater
//
//  Created by Michael on 8/9/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static let dateFormatter = DateFormatter()
    
    //TODO: Can make another function to do the conversion
    class func monthYearFormatter(using locale: Locale = .current) -> DateFormatter {
        
        let formatterTemplate = DateFormatter.dateFormat(fromTemplate: "MMMM YYYY", options: 0, locale: .current)
        
        dateFormatter.dateFormat = formatterTemplate
        
        return dateFormatter
        
    }
    
}
