//
//  RatingHistoryViewController.swift
//  DayRater
//
//  Created by Michael on 22/8/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import UIKit

class RatingHistoryViewController: UIViewController {

    let viewModel = RatingHistoryViewControllerViewModel(coreData: .shared)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupViews() {
        
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
