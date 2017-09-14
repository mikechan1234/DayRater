//
//  KeyboardInputEventHandler.swift
//  DayRater
//
//  Created by Michael on 12/9/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import UIKit

import ReactiveSwift
import Result

protocol KeyboardInputEventHandler {
    
    var scrollView: UIScrollView! {get set}
    var scrollViewBottomConstraint: NSLayoutConstraint! {get set}
    
    var didShowKeyboardDisposable: Disposable! {get set}
    var willHideKeyboardDisposable: Disposable! {get set}
    
    func didShowKeyboard(from results: Result<Notification, NoError>)
    func willHideKeyboard(from results: Result<Notification, NoError>)
    
}
