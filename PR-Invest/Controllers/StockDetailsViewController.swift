//
//  StockDetailsViewController.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 03.04.2022.
//

import UIKit

class StockDetailsViewController: UIViewController {
  
  private var model: SearchResult?
  private let symbol: String
  private let companyName: String
  private var candleStickData: [CandleStick]
  
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
    // Do any additional setup after loading the view.
  }
}
