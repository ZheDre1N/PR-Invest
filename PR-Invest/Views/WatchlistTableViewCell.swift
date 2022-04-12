//
//  WatchlistTableViewCell.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 08.04.2022.
//

import UIKit

protocol WatchlistTableViewCellDelegate: AnyObject {
  func didUpdateMaxWidth()
}

class WatchlistTableViewCell: UITableViewCell {
  static let identifier = "WatchlistTableViewCell"
  static let prefferedHeight: CGFloat = 60
  weak var delegate: WatchlistTableViewCellDelegate?
  
  struct ViewModel {
    let symbol: String
    let companyName: String
    let price: String // formatted
    let changeColor: UIColor // red or green
    let changePercentage: String
    let chartViewModel: StockChartView.ViewModel
  }
  
  // SymbolLabel
  private let symbolLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .medium)
    return label
  }()
  
  // CompanyLabel
  private let companyLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 15, weight: .regular)
    return label
  }()
  
  // MiniChartView
  private let miniChartView: StockChartView = {
    let chartView = StockChartView()
    chartView.clipsToBounds = true
    chartView.isUserInteractionEnabled = false
    return chartView
  }()
  
  // PriceLabel
  private let priceLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    label.font = .systemFont(ofSize: 15, weight: .regular)
    return label
  }()
  
  // Change in priceLabel
  private let changeLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    label.textColor = .white
    label.font = .systemFont(ofSize: 15, weight: .regular)
    label.layer.masksToBounds = true
    label.layer.cornerRadius = 6
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.clipsToBounds = true
    addSubviews(symbolLabel, companyLabel, miniChartView, priceLabel, changeLabel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    symbolLabel.sizeToFit()
    companyLabel.sizeToFit()
    priceLabel.sizeToFit()
    changeLabel.sizeToFit()
    
    let yStart = (contentView.height - symbolLabel.height - companyLabel.height) / 2
    let currentWidth = max(
      max(priceLabel.width, changeLabel.width),
      WatchListViewController.maxChangedWidth
    )
    
    if currentWidth > WatchListViewController.maxChangedWidth {
      WatchListViewController.maxChangedWidth = currentWidth
      delegate?.didUpdateMaxWidth()
    }
    
    symbolLabel.frame.origin = CGPoint(
      x: separatorInset.left,
      y: yStart
    )
    
    companyLabel.frame.origin = CGPoint(
      x: separatorInset.left,
      y: symbolLabel.bottom
    )
    
    priceLabel.frame = CGRect(
      x: contentView.width - 10 - currentWidth,
      y: (contentView.height - priceLabel.height - changeLabel.height) / 2,
      width: currentWidth,
      height: priceLabel.height
    )
    
    changeLabel.frame = CGRect(
      x: contentView.width - 10 - currentWidth,
      y: priceLabel.bottom,
      width: currentWidth,
      height: changeLabel.height
    )
    
    miniChartView.frame = CGRect(
      x: priceLabel.left - (contentView.width / 3) - 5,
      y: 6,
      width: contentView.width / 3,
      height: contentView.height - 12
    )
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
    miniChartView.configure(with: viewModel.chartViewModel)
  }
}
