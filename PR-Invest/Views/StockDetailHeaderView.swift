//
//  StockDetailHeaderView.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 11.04.2022.
//

import UIKit

class StockDetailHeaderView: UIView {
  // ChartView
  private let chartView = StockChartView()
  
  // CollectionView
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    // register cell
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .red
    return collectionView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    clipsToBounds = true
    addSubviews(chartView, collectionView)
    collectionView.dataSource = self
    collectionView.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    chartView.frame = CGRect(x: 0, y: 0, width: width, height: height - 100)
    collectionView.frame = CGRect(x: 0, y: height - 100, width: width, height: 100)
  }
  
  public func configure(
    with viewModel: StockChartView.ViewModel
  ) {
    
  }
}

extension StockDetailHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(width: width / 2, height: height / 3)
  }
}
