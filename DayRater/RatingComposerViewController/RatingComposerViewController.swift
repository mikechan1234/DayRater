//
//  RatingComposerViewController.swift
//  DayRater
//
//  Created by Michael on 6/9/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import UIKit

import ReactiveCocoa
import ReactiveSwift
import Result

class RatingComposerViewController: UIViewController {

    var viewModel: RatingComposerViewControllerViewModel!
    
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    var collectionView: UICollectionView!
    var ratingSelectorView: RatingComposerSelectorView = RatingComposerSelectorView.viewFor(nibName: "RatingComposerSelectorView")
    var descriptionTextView: RatingComposerTextView = RatingComposerTextView.viewFor(nibName: "RatingComposerTextView")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        bindViewModel()
    }
    
    fileprivate func setupViews() {
        
        title = "Rate Your Day"
        navigationItem.largeTitleDisplayMode = .never
        
        saveBarButtonItem.reactive.pressed = CocoaAction(Action<Void, Void, NoError>(execute: {[weak self] () -> SignalProducer<Void, NoError> in

            guard let weakSelf = self else {

                return SignalProducer.empty

            }

            return weakSelf.viewModel.saveRating().flatMap(.merge, {[weak self] (value) -> SignalProducer<Void, NoError> in

                guard let weakSelf = self else {

                    return SignalProducer.empty

                }

                return weakSelf.handleSaveRating(from: value)

            })

        }))
        
        scrollView.isScrollEnabled = false
        
        let flowLayout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        collectionView.dataSource = self
        
        containerView.layout(views: [collectionView, ratingSelectorView, descriptionTextView], for: .vertical, sidePadding: 5)
        
        ratingSelectorView.negativeButton.reactive.controlEvents(.touchUpInside).observeResult {[weak self] (result) in

            self?.viewModel.selectedRating.value = 0

        }

        ratingSelectorView.positiveButton.reactive.controlEvents(.touchUpInside).observeResult {[weak self] (result) in

            self?.viewModel.selectedRating.value = 1

        }

    }
    
    fileprivate func bindViewModel() {
        
        saveBarButtonItem.reactive.isEnabled <~ viewModel.ratingValidation
        
    }

}

extension RatingComposerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        return cell
        
    }
    
}

extension RatingComposerViewController: UICollectionViewDelegateFlowLayout {
    
    
    
}

extension RatingComposerViewController {
    
    fileprivate func handleSaveRating(from value: Bool) -> SignalProducer<Void, NoError> {
        
        return SignalProducer<Void, NoError>({[weak self] (observer, lifetime) in
            
            if !value {
                
                let alertController = UIAlertController(title: "Oops", message: "There was an issue saving your rating", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                
                self?.present(alertController, animated: true, completion: nil)
                
            } else {
                
                self?.navigationController?.popToRootViewController(animated: true)
                
            }
            
            observer.sendCompleted()
            
        }).observe(on: UIScheduler())
        
    }
    
}
