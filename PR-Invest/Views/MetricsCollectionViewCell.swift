//
//  MetricsCollectionViewCell.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 12.04.2022.
//

import UIKit

class MetricsCollectionViewCell: UICollectionViewCell {
  static let identifier = "MetricsCollectionViewCell"
  
  struct ViewModel {
    let name: String
    let value: String
  }
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .label
    return label
  }()
  
  private let valueLabel: UILabel = {
    let label = UILabel()
    label.textColor = .secondaryLabel
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubviews(nameLabel, valueLabel)
    contentView.clipsToBounds = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    valueLabel.sizeToFit()
    nameLabel.sizeToFit()
    
    nameLabel.frame = CGRect(
      x: 3,
      y: 0,
      width: nameLabel.width,
      height: contentView.height
    )
    
    valueLabel.frame = CGRect(
      x: nameLabel.right + 3,
      y: 0,
      width: valueLabel.width,
      height: contentView.height
    )
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    nameLabel.text = nil
    valueLabel.text = nil
  }
  
  public func configure(with viewModel: ViewModel) {
    nameLabel.text = viewModel.name + ":"
    valueLabel.text = viewModel.value
  }
}
