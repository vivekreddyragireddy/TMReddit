//
//  ViewController.swift
//  TMReddit
//
//  Created by vivek on 1/10/18.
//  Copyright © 2018 vivek. All rights reserved.
//

import UIKit
import SDWebImage

/// TMHomeViewController is responsible for showing list of cards from reddit.

class TMHomeViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var homeTableView: UITableView!
    
    // MARK: - Properties
    private(set) var cards = [TMCard]()
    private(set) var afterLink: String?
    private(set) var isLoadingData: Bool = false
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        getData()
    }
    
    // MARK: - Custom Methods
    private func configureTableView() {
        homeTableView.rowHeight = UITableViewAutomaticDimension
        homeTableView.estimatedRowHeight = 140
    }
    
    private func getData() {
        // check network rechability
        if let network = Reachability()?.connection, network == .none {
            let alert = UIAlertController(title: "Error", message: "No Network Connection available", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        // return if already making a service call
        if isLoadingData {
            return
        }
        // show status bar activity indicator
        isLoadingData = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // invoke service
        TMDataManager.getCards(after: afterLink) { [weak self] (data) in
            guard let strongSelf = self else {
                return
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let data = data, let newCards = data.cards {
                strongSelf.cards += newCards
                strongSelf.afterLink = data.afterLink
                strongSelf.homeTableView.reloadData()
                strongSelf.isLoadingData = false
            }
        }
    }
    
}
// MARK: - UITableViewDataSource Methods
extension TMHomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as? TMHomeTableViewCell else {
            assertionFailure("Unable to dequeue cell")
            return UITableViewCell()
        }
        let card = cards[indexPath.row]
        cell.configureCell(card: card)
        return cell
    }
}

// MARK: - UITableViewDelegate Methods
extension TMHomeViewController : UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 50.0 {
            getData()
        }
    }
}

