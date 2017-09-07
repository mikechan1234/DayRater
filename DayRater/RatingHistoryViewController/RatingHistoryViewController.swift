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
    @IBOutlet weak var tableView: UITableView!
    
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
        
        
        tableView.register(UINib(nibName: RatingHistoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RatingHistoryTableViewCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
    
    }
    
    fileprivate func bindViewModel() {
        
        viewModel.willChangeContentSignal.observeValues { [unowned self] in
            
            self.tableView.beginUpdates()
        
        }
        
        viewModel.didChangeContentSignal.observeValues { [unowned self] in
            
            self.tableView.endUpdates()
            
        }
        
        viewModel.didChangeObjectSignal.observeValues { [unowned self] (object, atIndexPath, type, newIndexPath) in
            
            switch type {
                
            case .delete:
                self.tableView.deleteRows(at: [atIndexPath!], with: .automatic)
                break
                
            case .insert:
                self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
                break
                
            case .move:
                self.tableView.moveRow(at: atIndexPath!, to: newIndexPath!)
                break
                
            case .update:
                self.tableView.reloadRows(at: [atIndexPath!], with: .automatic)
                break
                
            }
            
        }
        
    }

}

extension RatingHistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
    
        return viewModel.numberOfSections()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfItems(for: section)
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RatingHistoryTableViewCell.identifier, for: indexPath) as! RatingHistoryTableViewCell
        
        cell.configure(using: viewModel.cellContents(for: indexPath))
        
        return cell
        
    }
    
}

extension RatingHistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
