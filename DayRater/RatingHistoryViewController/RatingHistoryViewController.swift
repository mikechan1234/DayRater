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
