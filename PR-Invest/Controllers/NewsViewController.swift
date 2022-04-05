//
//  TopStoriesViewController.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 03.04.2022.
//

import UIKit

class NewsViewController: UIViewController {
  
  private var newsType: NewsType
  private var watchList = [String]()
  
  public var tableView: UITableView = {
    let table = UITableView()
    table.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
    table.backgroundColor = .clear
    return table
  }()
  
  enum NewsType {
    case topStories
    case company(ticker: String)
    
    var title: String {
      switch self {
      case .topStories:
        return "Top Stories"
      case .company(let ticker):
        return ticker.uppercased()
      }
    }
  }
  
  init(newsType: NewsType) {
    self.newsType = newsType
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpTable()
    fetchNews()
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
  
  private func fetchNews() {
    
  }
  
  private func open(url: URL) {
    
  }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.identifier) as? NewsHeaderView else {
      return nil
    }
    header.configure(with: NewsHeaderView.ViewModel(
      title: self.newsType.title,
      shouldShowAddButton: false
    ))
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    NewsHeaderView.prefferedHeight
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    140
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
