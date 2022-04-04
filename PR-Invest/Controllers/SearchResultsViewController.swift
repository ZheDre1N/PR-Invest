//
//  SearchResultsViewController.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 03.04.2022.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
  func searchResultsViewControllerDidSelect(searchResult: SearchResult)
}

class SearchResultsViewController: UIViewController {
  
  weak var delegate: SearchResultsViewControllerDelegate?
  private var results: [SearchResult] = []
  
  private let tableView: UITableView = {
    let table = UITableView()
    // register a cell
    table.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
    table.isHidden = true
    return table
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
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
  
  public func update(with result: [SearchResult]) {
    self.results = result
    tableView.isHidden = results.isEmpty
    tableView.reloadData()
  }
}

extension SearchResultsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    results.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath)
    
    let cellModel = results[indexPath.row]
    
    cell.textLabel?.text = cellModel.displaySymbol
    cell.detailTextLabel?.text = cellModel.description
    
    return cell
  }
}

extension SearchResultsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let cellModel = results[indexPath.row]
    delegate?.searchResultsViewControllerDidSelect(searchResult: cellModel)
  }
}
