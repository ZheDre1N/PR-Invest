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
    static let onboardedKey = "hasOnBoarded"
    static let watchlistKey = "watchlist"
  }
  
  private init() {}
  
  // MARK: Public
  
  public var watchlist: [String] {
    if !hasOnBoarded {
      userDefaults.set(true, forKey: Constants.onboardedKey)
      setUpDefaults()
    }
    return userDefaults.stringArray(forKey: Constants.watchlistKey) ?? []
  }
  
  public func watchListContains(symbol: String) -> Bool {
    return watchlist.contains(symbol)
  }
  
  public func addToWatchlist(symbol: String, companyName: String) {
    var current = watchlist
    current.append(symbol)
    userDefaults.set(current, forKey: Constants.onboardedKey)
    userDefaults.set(companyName, forKey: symbol)
    NotificationCenter.default.post(name: .didAddToWatchList, object: nil)
  }
  
  public func removeFromWatchlist(symbol deletedSymbol: String) {
    var newList = [String]()
    userDefaults.set(nil, forKey: deletedSymbol)
    for item in watchlist where item != deletedSymbol {
      newList.append(item)
      
    }
    userDefaults.set(newList, forKey: Constants.watchlistKey)
  }
  
  // MARK: Private

  private var hasOnBoarded: Bool {
    return userDefaults.bool(forKey: Constants.onboardedKey)
  }
  
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
