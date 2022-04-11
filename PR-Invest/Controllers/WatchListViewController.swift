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
  static var maxChangedWidth: CGFloat = 0
  private var observer: NSObjectProtocol?
  
  // Model
  private var watchlistMap: [String: [CandleStick]] = [:]
  
  // ViewModel
  private var viewModels: [WatchlistTableViewCell.ViewModel] = []
  
  private var tableView: UITableView = {
    let table = UITableView()
    table.register(WatchlistTableViewCell.self, forCellReuseIdentifier: WatchlistTableViewCell.identifier)
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
    setUpObserver()
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  private func setUpObserver() {
    observer = NotificationCenter.default.addObserver(forName: .didAddToWatchList, object: nil, queue: .main
    ) { [weak self] _ in
      self?.viewModels.removeAll()
      self?.setUpWatchlistData()
    }
  }
  
  private func setUpSearchController() {
    let resultVC = SearchResultsViewController()
    resultVC.delegate = self
    let searchVC = UISearchController(searchResultsController: resultVC)
    searchVC.searchResultsUpdater = self
    navigationItem.searchController = searchVC
  }
  
  private func setUpTableView() {
    view.addSubviews(tableView)
  }
  
  private func setUpWatchlistData() {
    let symbols = PersistenceManager.shared.watchlist
    
    let group = DispatchGroup()
    
    for symbol in symbols where watchlistMap[symbol] == nil {
      group.enter()
      APICaller.shared.marketData(for: symbol) { [weak self] result in
        
        defer {
          group.leave()
        }
        
        switch result {
        case .success(let data):
          let candleSticks = data.candleSticks
          self?.watchlistMap[symbol] = candleSticks
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
    group.notify(queue: .main) { [weak self] in
      self?.createViewModels()
      self?.tableView.reloadData()
    }
  }
  
  private func createViewModels() {
    var viewModels = [WatchlistTableViewCell.ViewModel]()
    for (symbol, candleSticks) in watchlistMap {
      let changePercentage = getChangePercentage(for: candleSticks)
      viewModels.append(.init(
        symbol: symbol,
        companyName: UserDefaults.standard.string(forKey: symbol) ?? "Noname company",
        price: getLatestClosingPrice(from: candleSticks),
        changeColor:  changePercentage < 0 ? .systemRed : .systemGreen,
        changePercentage: String.percentage(from: changePercentage),
        chartViewModel: .init(data: candleSticks.reversed().map { $0.close }, showLegend: false, showAxis: false)
      ))
    }
    self.viewModels = viewModels
  }
  
  private func getLatestClosingPrice(from data: [CandleStick]) -> String {
    guard let closingPrice = data.first?.close else {
      return ""
    }
    return .formatted(number: closingPrice)
  }
  
  private func getChangePercentage(for data: [CandleStick]) -> Double {
    let latestDate = data[0].date
    guard let latestClose = data.first?.close,
          let priorClose = data.first(where: {
            !Calendar.current.isDate($0.date, inSameDayAs: latestDate)
          })?.close else {
      return 0
    }
    
    let diff = 1 - priorClose/latestClose
    return diff
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
    let vc = StockDetailsViewController(
      symbol: searchResult.displaySymbol,
      companyName: searchResult.description
    )
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
    return viewModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: WatchlistTableViewCell.identifier,
      for: indexPath
    ) as? WatchlistTableViewCell else {
      return UITableViewCell()
    }
    cell.delegate = self
    cell.configure(with: viewModels[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return WatchlistTableViewCell.prefferedHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    // Open details for selection
    let viewModel = viewModels[indexPath.row]
    let vc = StockDetailsViewController(
      symbol: viewModel.symbol,
      companyName: viewModel.companyName,
      candleStickData: watchlistMap[viewModel.symbol] ?? []
    )
    let navVC = UINavigationController(rootViewController: vc)
    present(navVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      tableView.beginUpdates()
      PersistenceManager.shared.removeFromWatchlist(symbol: viewModels[indexPath.row].symbol)
      viewModels.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
      tableView.endUpdates()
    }
  }
}


extension WatchListViewController: WatchlistTableViewCellDelegate {
  func didUpdateMaxWidth() {
    tableView.reloadData()
  }
}
