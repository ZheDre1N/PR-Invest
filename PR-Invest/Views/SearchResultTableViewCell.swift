//
//  SearchResultTableViewCell.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 04.04.2022.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
  static let identifier = "SearchResultTableViewCell"
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
