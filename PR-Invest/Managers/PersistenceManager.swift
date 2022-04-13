//
//  PersistanceManager.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 03.04.2022.
//

import Foundation

/// Object to manage saved caches
final class PersistenceManager {
  /// Singleton
  static let shared = PersistenceManager()
  private init() {}

  /// Reference to user defaults
  private let userDefaults: UserDefaults = .standard
  
  /// Constants
  private enum Constants {
    static let onboardedKey = "hasOnBoarded"
    static let watchlistKey = "watchlist"
  }
  
  // MARK: Public
  
  /// Get user watchlist
  public var watchlist: [String] {
    if !hasOnBoarded {
      userDefaults.set(true, forKey: Constants.onboardedKey)
      setUpDefaults()
    }
    return userDefaults.stringArray(forKey: Constants.watchlistKey) ?? []
  }
  
  /// Check if watchlist contains item
  /// - Parameter symbol: Symbol to check
  /// - Returns: Boolean
  public func watchListContains(symbol: String) -> Bool {
    return watchlist.contains(symbol)
  }
  
  /// Add a symbol to watchlist
  /// - Parameters:
  ///   - symbol: Symbol to add
  ///   - companyName: Company name for symbol being added
  public func addToWatchlist(symbol: String, companyName: String) {
    var current = watchlist
    current.append(symbol)
    userDefaults.set(current, forKey: Constants.watchlistKey)
    userDefaults.set(companyName, forKey: symbol)
    NotificationCenter.default.post(name: .didAddToWatchList, object: nil)
  }
  
  /// Remove item from watchlist
  /// - Parameter deletedSymbol: Symbol to remove
  public func removeFromWatchlist(symbol deletedSymbol: String) {
    var newList = [String]()
    userDefaults.set(nil, forKey: deletedSymbol)
    for item in watchlist where item != deletedSymbol {
      newList.append(item)
      
    }
    userDefaults.set(newList, forKey: Constants.watchlistKey)
  }
  
  // MARK: Private
  
  /// Check if user has been onboarded
  private var hasOnBoarded: Bool {
    return userDefaults.bool(forKey: Constants.onboardedKey)
  }
  
  /// Set up default watchlist
  private func setUpDefaults() {
    let map: [String: String] = [
      "AAPL": "Apple Inc",
      "FB": "Facebook Corporation",
      "CRM": "Snap Inc",
      "GOOG": "Alphabet",
      "AMZN": "Amazon",
      "SNAP": "Snapchat"
    ]
    
    let symbols = map.keys.map { $0 }
    userDefaults.set(symbols, forKey: Constants.watchlistKey)
    
    for (symbol, name) in map {
      userDefaults.set(name, forKey: symbol)
    }
  }
}
