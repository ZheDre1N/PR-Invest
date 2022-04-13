//
//  TopStoriesViewController.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 03.04.2022.
//

import UIKit
import SafariServices

class NewsViewController: UIViewController {
  
  private var newsType: NewsType
  private var stories = [NewsStory]()
  
  public var tableView: UITableView = {
    let table = UITableView()
    table.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
    table.register(NewsStoryTableViewCell.self, forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
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
    APICaller.shared.news(for: .topStories) { [weak self] result in
      switch result {
      case .success(let stories):
        DispatchQueue.main.async {
          self?.stories = stories
          self?.tableView.reloadData()
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  private func open(url: URL) {
    let vc = SFSafariViewController(url: url)
    present(vc, animated: true)
  }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    stories.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.identifier, for: indexPath) as? NewsStoryTableViewCell else { return UITableViewCell() }
    cell.configure(with: .init(model: stories[indexPath.row]))
    return cell
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
    NewsStoryTableViewCell.preferredHeigh
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    HapticsManager.shared.vibrateForSelection()
    
    // Open story page
    let story = stories[indexPath.row]
    guard let url = URL(string: story.url) else {
      presentFailedToOpenAlert()
      return
    }
    open(url: url)
  }
  
  private func presentFailedToOpenAlert() {
    HapticsManager.shared.vibrate(for: .error)
    
    let alert = UIAlertController(
      title: "Unable to open",
      message: "We were unable to open the article.",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
    present(alert, animated: true)
  }
}
