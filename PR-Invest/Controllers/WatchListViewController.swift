//
//  ViewController.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 03.04.2022.
//

import UIKit
import FloatingPanel

class WatchListViewController: UIViewController {
  
  private var searchTimer: Timer?
  private var panel: FloatingPanelController?
  
  // Model
  private var watchlistMap: [String: [String]] = [:]
  
  
  // ViewModel
  private var viewModels: [String] = []
  
  
  private var tablewView: UITableView = {
    let table = UITableView()
    return table
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setUpSearchController()
    setUpTableView()
    setUpWatchlistData()
    setUpTitleView()
    setUpFloatingPanel()
    tablewView.delegate = self
    tablewView.dataSource = self
  }
  
  private func setUpSearchController() {
    let resultVC = SearchResultsViewController()
    resultVC.delegate = self
    let searchVC = UISearchController(searchResultsController: resultVC)
    searchVC.searchResultsUpdater = self
    navigationItem.searchController = searchVC
  }
  
  private func setUpTableView() {
    
  }
  
  private func setUpWatchlistData() {
    let symbols = PersistenceManager.shared.watchlist
    for symbol in symbols {
      // Fetch market data
      watchlistMap[symbol] = ["some string"]
    }
  }
  
  private func setUpTitleView() {
    let titleView = UIView(frame: CGRect(
      x: 0,
      y: 0,
      width: view.width,
      height: navigationController?.navigationBar.height ?? 100
    ))
    
    let label = UILabel(frame: CGRect(x: 10, y: 0, width: titleView.width - 20, height: titleView.height))
    label.text = "Watchlist"
    label.font = .systemFont(ofSize: 24, weight: .bold)
    titleView.addSubview(label)
    navigationItem.titleView = titleView
  }
  
  private func setUpFloatingPanel() {
    let panel = FloatingPanelController(delegate: self)
    let vc = NewsViewController(newsType: .topStories)
    panel.surfaceView.backgroundColor = .secondarySystemBackground
    panel.set(contentViewController: vc)
    panel.addPanel(toParent: self)
    panel.track(scrollView: vc.tableView)
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
    
    // reset timer
    searchTimer?.invalidate()
    
    // Optimize search text
    searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
      
      APICaller.shared.search(query: query) { result in
        switch result {
        case .success(let response):
          DispatchQueue.main.async {
            resultVC.update(with: response.result)
          }
        case .failure(let error):
          DispatchQueue.main.async {
            print(error.localizedDescription)
            resultVC.update(with: [])
          }
        }
      }
    })
  }
}

extension WatchListViewController: SearchResultsViewControllerDelegate {
  func searchResultsViewControllerDidSelect(searchResult: SearchResult) {
    navigationItem.searchController?.searchBar.resignFirstResponder()
    let vc = StockDetailsViewController()
    let navVC = UINavigationController(rootViewController: vc)
    vc.title = searchResult.description
    present(navVC, animated: true)
  }
}

extension WatchListViewController: FloatingPanelControllerDelegate {
  func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
    navigationItem.titleView?.isHidden = fpc.state == .full
    navigationItem.searchController?.searchBar.isHidden = fpc.state == .full
  }
}

extension WatchListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    watchlistMap.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    // Open details for selection
  }
}
