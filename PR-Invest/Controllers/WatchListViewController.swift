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
    setUpSearchController()
    setUpTitleView()
    // Do any additional setup after loading the view.
  }

  private func setUpSearchController() {
    let resultVC = SearchResultsViewController()
    resultVC.delegate = self
    let searchVC = UISearchController(searchResultsController: resultVC)
    searchVC.searchResultsUpdater = self
    navigationItem.searchController = searchVC
  }
  
  private func setUpTitleView() {
    let titleView = UIView(frame: CGRect(
      x: 0,
      y: 0,
      width: view.width,
      height: navigationController?.navigationBar.height ?? 100
    ))
    
    let label = UILabel(frame: CGRect(x: 10, y: 0, width: titleView.width - 20, height: titleView.height))
    label.text = "PR-Invest"
    label.font = .systemFont(ofSize: 24, weight: .bold)
    titleView.addSubview(label)
    navigationItem.titleView = titleView
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
    resultVC.update(with: ["AAPL", "CRM"])
    
  }
}

extension WatchListViewController: SearchResultsViewControllerDelegate {
  func searchResultsViewControllerDidSelect(searchResult: String) {
    // present stocks detail for given selection
  }
}
