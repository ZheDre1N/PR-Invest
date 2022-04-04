//
//  SearchResultsViewController.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 03.04.2022.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
  func searchResultsViewControllerDidSelect(searchResult: String)
}

class SearchResultsViewController: UIViewController {
  
  weak var delegate: SearchResultsViewControllerDelegate?
  private var results: [String] = []
  
  private let tableView: UITableView = {
    let table = UITableView()
    // register a cell
    table.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
    return table
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
    setUpTable()
    // Do any additional setup after loading the view.
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  private func setUpTable() {
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  public func update(with result: [String]) {
    self.results = result
    tableView.reloadData()
  }
}

extension SearchResultsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath)
    
    cell.textLabel?.text = "AAPL"
    cell.detailTextLabel?.text = "Apple Inc."
    
    return cell
  }
}

extension SearchResultsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    delegate?.searchResultsViewControllerDidSelect(searchResult: "AAPL")
  }
}
