//
//  StockDetailsViewController.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 03.04.2022.
//

import UIKit
import SafariServices

class StockDetailsViewController: UIViewController {
  
  private var model: SearchResult?
  private let symbol: String
  private let companyName: String
  private var candleStickData: [CandleStick]
  private var stories: [NewsStory] = []
  
  private let tableView: UITableView = {
    let table = UITableView()
    table.register(
      NewsHeaderView.self,
      forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier
    )
    table.register(
      NewsStoryTableViewCell.self,
      forCellReuseIdentifier: NewsStoryTableViewCell.identifier
    )
    return table
  }()
  
  init(
    symbol: String,
    companyName: String,
    candleStickData: [CandleStick] = []
  ) {
    self.symbol = symbol
    self.companyName = companyName
    self.candleStickData = candleStickData
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = companyName
    setUpCloseButton()
    setUpTable()
    fetchFinancialData()
    fetchNews()
    // Do any additional setup after loading the view.
    
    // show view
    
    
    // fetchfinancial data
    
    
    // show chart
    
    
    // show news
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  private func setUpCloseButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .close,
      target: self,
      action: #selector(didTapClose)
    )
  }
  
  @objc private func didTapClose() {
    dismiss(animated: true)
  }
  
  private func setUpTable() {
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableHeaderView = UIView(frame: CGRect(
      x: 0,
      y: 0,
      width: view.width,
      height: (view.width * 0.7) + 100
    ))
  }
  
  private func fetchFinancialData() {
    //fetch candle stick if needeed
    
    // fetch financial metrics
    
    renderChart()
  }
  
  private func fetchNews() {
    APICaller.shared.news(
      for: .company(ticker: symbol)) { [weak self] result in
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
  
  private func renderChart() {
    
  }
}

extension StockDetailsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stories.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: NewsStoryTableViewCell.identifier,
      for: indexPath
    ) as? NewsStoryTableViewCell else {
      return UITableViewCell()
    }
    
    cell.configure(with: .init(model: stories[indexPath.row]))
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return NewsStoryTableViewCell.preferredHeigh
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let header = tableView.dequeueReusableHeaderFooterView(
      withIdentifier: NewsHeaderView.identifier
    ) as? NewsHeaderView else {
      return nil
    }
    header.delegate = self
    header.configure(with: .init(
      title: symbol.uppercased(),
      shouldShowAddButton: !PersistenceManager.shared.watchListContains(symbol: symbol)
    ))
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return NewsHeaderView.prefferedHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let url = URL(string: stories[indexPath.row].url) else { return }
    let vc = SFSafariViewController(url: url)
    present(vc, animated: true)
  }
}

extension StockDetailsViewController: NewsHeaderViewDelegate {
  func newsHeaderViewDidTapAddButton(_ headerView: NewsHeaderView) {
    // add to watchlist
    headerView.button.isHidden = true
    PersistenceManager.shared.addToWatchlist(
      symbol: symbol,
      companyName: companyName
    )
    
    let alert = UIAlertController(
      title: "Added to Watchlist",
      message: "We've added \(companyName) to tour watchlist.",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
    present(alert, animated: true)
  }
}


