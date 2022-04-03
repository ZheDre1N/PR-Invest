//
//  PersistanceManager.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 03.04.2022.
//

import Foundation

final class PersistenceManager {
  static let shared = PersistenceManager()
  
  private let userDefaults: UserDefaults = .standard
  
  private enum Constants {
    
  }
  
  private init() {}
  
  // MARK: Public
  
  public var watchiist: [String] {
    return []
  }
  
  public func addToWatchlist() {
    
  }
  
  public func removeFromWatchlist() {
    
  }
  
  // MARK: Private

  private var hasOnBoarded: Bool {
    return false
  }
}
