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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    var didShowKeyboardDisposable: Disposable!
    var willHideKeyboardDisposable: Disposable!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        didShowKeyboardDisposable = NotificationCenter.default.reactive.notifications(forName: .UIKeyboardDidShow).observeResult(didShowKeyboard)
        willHideKeyboardDisposable = NotificationCenter.default.reactive.notifications(forName: .UIKeyboardWillHide).observeResult(willHideKeyboard)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        didShowKeyboardDisposable.dispose()
        willHideKeyboardDisposable.dispose()
        
    }
    
    //MARK: KeyboardInputEventHandler

    /// Updates the scrollViewBottomConstraint based on the safeArea
    ///
    /// - Parameter results: Notification Result with NoError
    func didShowKeyboard(from results: Result<Notification, NoError>) {
        
        guard let keyboardSize = results.value?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            
            return
            
        }

        scrollViewBottomConstraint.constant = -(keyboardSize.height - (view.bounds.height - (view.safeAreaLayoutGuide.layoutFrame.height + view.safeAreaLayoutGuide.layoutFrame.origin.y)))
        
    }
    
    func willHideKeyboard(from results: Result<Notification, NoError>) {
        
        scrollViewBottomConstraint.constant = 0

    }
    
}
