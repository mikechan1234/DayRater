//
//  InputViewController.swift
//  DayRater
//
//  Created by Michael on 12/9/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import UIKit

import ReactiveSwift
import Result

class InputViewController: UIViewController, KeyboardInputEventHandler {
    
    var scrollView: UIScrollView!
    var scrollViewBottomConstraint: NSLayoutConstraint!
    
    var willShowKeyboardDisposable: Disposable!
    var didHideKeyboardDisposable: Disposable!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        willShowKeyboardDisposable = NotificationCenter.default.reactive.notifications(forName: .UIKeyboardWillShow).observeResult(willShowKeyboard)
        didHideKeyboardDisposable = NotificationCenter.default.reactive.notifications(forName: .UIKeyboardDidHide).observeResult(didHideKeyboard)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        willShowKeyboardDisposable.dispose()
        didHideKeyboardDisposable.dispose()
        
    }
    
    //MARK: KeyboardInputEventHandler
    
    func willShowKeyboard(from results: Result<Notification, NoError>) {
        
    }
    
    func didHideKeyboard(from results: Result<Notification, NoError>) {
        
    }
    
}
