//
//  ViewController.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 03.04.2022.
//

import UIKit

class WatchListViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = "PR Invest"
    setUpSearchController()
    // Do any additional setup after loading the view.
  }

  private func setUpSearchController() {
    let resultVC = SearchResultsViewController()
    let searchVC = UISearchController(searchResultsController: resultVC)
    searchVC.searchResultsUpdater = self
    
    
    navigationItem.searchController = searchVC
  }

}

extension WatchListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let query = searchController.searchBar.text,
          !query.trimmingCharacters(in: .whitespaces).isEmpty,
          let resultVC = searchController.searchResultsController as? SearchResultsViewController
    else {
      return
    }
    
    // Optimize search text
    
    // Call API to search
    
    // update result VC
    print(query)
    
  }
}
