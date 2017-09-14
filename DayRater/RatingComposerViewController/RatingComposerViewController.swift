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

class RatingComposerViewController: InputViewController {

    var viewModel: RatingComposerViewControllerViewModel!
    
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var containerViewHeight: NSLayoutConstraint!
    var collectionView: UICollectionView! = {
       
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
        
    }()
    var ratingSelectorView: RatingComposerSelectorView = RatingComposerSelectorView.viewFor(nibName: "RatingComposerSelectorView")
    var descriptionTextView: RatingComposerTextView = RatingComposerTextView.viewFor(nibName: "RatingComposerTextView")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        bindViewModel()
        
    }
    
    fileprivate func setupViews() {
        
        title = "Rate My Day"
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
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "RatingComposerStatusCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RatingComposerStatusCollectionViewCell")
        
        containerView.layout(views: [collectionView, ratingSelectorView, descriptionTextView], for: .vertical, topPadding: 10, bottomPadding: 10, sidePadding: 10, interitemPadding: 10)
        
        ratingSelectorView.negativeButton.reactive.controlEvents(.touchUpInside).observeResult {[weak self] (result) in

            self?.collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredVertically, animated: true)
            self?.viewModel.selectedRating.value = 0

        }

        ratingSelectorView.positiveButton.reactive.controlEvents(.touchUpInside).observeResult {[weak self] (result) in

            self?.collectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .centeredVertically, animated: true)
            self?.viewModel.selectedRating.value = 1

        }
        
        descriptionTextView.textView.text = viewModel.ratingDescription.value

    }
    
    fileprivate func bindViewModel() {
        
        saveBarButtonItem.reactive.isEnabled <~ viewModel.ratingValidation
        
        viewModel.ratingDescription <~ descriptionTextView.textView.reactive.continuousTextValues.skipNil()
        
    }
    
    override func didShowKeyboard(from results: Result<Notification, NoError>) {
        super.didShowKeyboard(from: results)
        
        containerViewHeight.constant = scrollViewBottomConstraint.constant
        
    }
    
    override func willHideKeyboard(from results: Result<Notification, NoError>) {
        super.willHideKeyboard(from: results)
        
        containerViewHeight.constant = 0
                
    }

}

extension RatingComposerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RatingComposerStatusCollectionViewCell", for: indexPath) as! RatingComposerStatusCollectionViewCell
        
        switch indexPath.row {
        case 0:
            cell.configure(for: .question)
            break
        case 1:
            cell.configure(for: .negative)
            break
        case 2:
            cell.configure(for: .positive)
            break
        default:
            break
        }
        
        return cell
        
    }
    
}

extension RatingComposerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: 100)
        
    }
    
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
