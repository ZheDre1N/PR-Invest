//
//  WatchlistTableViewCell.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 08.04.2022.
//

import UIKit

class WatchlistTableViewCell: UITableViewCell {
  static let identifier = "WatchlistTableViewCell"
  static let prefferedHeight: CGFloat = 60
  
  struct ViewModel {
    let symbol: String
    let companyName: String
    let price: String // formatted
    let changeColor: UIColor // red or green
    let changePercentage: String
    // let chartViewModel: StockChartView.ViewModel
  }
  
  // SymbolLabel
  private let symbolLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 15, weight: .medium)
    return label
  }()
  
  // CompanyLabel
  private let companyLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 15, weight: .regular)
    return label
  }()
  
  // MiniChartView
  private let miniChartView = StockChartView()
  
  // PriceLabel
  private let priceLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 15, weight: .regular)
    return label
  }()
  
  // Change in priceLabel
  private let changeLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .systemFont(ofSize: 15, weight: .regular)
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubviews(symbolLabel, companyLabel, miniChartView, priceLabel, changeLabel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    symbolLabel.text = nil
    companyLabel.text = nil
    priceLabel.text = nil
    changeLabel.text = nil
    miniChartView.reset()
  }
  
  public func configure(with viewModel: ViewModel) {
    symbolLabel.text = viewModel.symbol
    companyLabel.text = viewModel.companyName
    priceLabel.text = viewModel.price
    changeLabel.text = viewModel.changePercentage
    changeLabel.backgroundColor = viewModel.changeColor
    // configure chart
  }
}
