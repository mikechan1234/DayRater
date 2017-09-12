//
//  RatingHistoryViewController.swift
//  DayRater
//
//  Created by Michael on 22/8/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import UIKit

import ReactiveCocoa
import ReactiveSwift
import Result

class RatingHistoryViewController: UIViewController {

    let viewModel = RatingHistoryViewControllerViewModel(coreData: .shared)
    
    @IBOutlet weak var composeBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindViewModel()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "toRatingComposer", let destinationViewController = segue.destination as? RatingComposerViewController, let viewModel = sender as? RatingComposerViewControllerViewModel {
            
            destinationViewController.viewModel = viewModel
            
        }
        
    }
    
    fileprivate func setupViews() {
        
        title = "Ratings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        composeBarButtonItem.reactive.pressed = CocoaAction(Action<Void, Void, NoError>(execute: {[weak self] () -> SignalProducer<Void, NoError> in
            
            return SignalProducer<Void, NoError>({ (observer, lifetime) in
              
                guard let weakSelf = self else {
                    
                    return
                    
                }
                
                let viewModel = weakSelf.viewModel.makeRatingComposerViewModel()
                
                weakSelf.performSegue(withIdentifier: "toRatingComposer", sender: viewModel)
                
                observer.sendCompleted()
                
            })
            
        }))
        
        collectionView.register(UINib(nibName: "RatingHistoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RatingHistoryCollectionViewCell")
        collectionView.register(UINib(nibName: "RatingHistoryHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "RatingHistoryHeaderCollectionReusableView")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        collectionView.collectionViewLayout = flowLayout
    
    }
    
    fileprivate func bindViewModel() {
        
        viewModel.didChangeObjectSignal.observeValues { [unowned self] (object, atIndexPath, type, newIndexPath) in
            
            switch type {
                
            case .delete:
                self.collectionView.deleteItems(at: [atIndexPath!])
                break
                
            case .insert:
                self.collectionView.insertItems(at: [newIndexPath!])
                break
                
            case .move:
                self.collectionView.moveItem(at: atIndexPath!, to: newIndexPath!)
                break
                
            case .update:
                self.collectionView.reloadItems(at: [atIndexPath!])
                break
                
            }
            
        }
        
        viewModel.didChangeSectionInfoSignal.observeValues {[unowned self] (sectionInfo, sectionIndex, type) in
            
            switch type {
                
            case .insert:
                self.collectionView.insertSections(IndexSet(integer: sectionIndex))
                break
            
            case .delete:
                self.collectionView.deleteSections(IndexSet(integer: sectionIndex))
                break
                
            default:
                break
                
            }
            
        }
        
    }

}

extension RatingHistoryViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return viewModel.numberOfSections()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.numberOfItems(for: section)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RatingHistoryCollectionViewCell", for: indexPath) as! RatingHistoryCollectionViewCell
        
        cell.configure(using: viewModel.cellContents(for: indexPath))
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RatingHistoryHeaderCollectionReusableView", for: indexPath) as! RatingHistoryHeaderCollectionReusableView
        
        header.titleLabel.text = viewModel.sectionTitle(for: indexPath.section)
        
        return header
        
    }
    
}

extension RatingHistoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width, height: 50)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        return CGSize(width: (collectionView.bounds.size.width - 20) / 3, height: (collectionView.bounds.size.width - 20) / 3)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
        
    }
    
}
