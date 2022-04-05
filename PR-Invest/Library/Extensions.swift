//
//  Extensions.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 04.04.2022.
//

import UIKit

// MARK: Framing

extension UIView {
  var width: CGFloat {
    frame.size.width
  }
  
  var height: CGFloat {
    frame.size.height
  }
  
  var left: CGFloat {
    frame.origin.x
  }
  
  var right: CGFloat {
    left + width
  }
  
  var top: CGFloat {
    frame.origin.y
  }
  
  var bottom: CGFloat {
    top + height
  }
}

extension UIView {
  func addSubviews(_ views: UIView...) {
    views.forEach { addSubview($0) }
  }
}

extension DateFormatter {
  static let newsDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-MM-dd"
    return formatter
  }()
}
