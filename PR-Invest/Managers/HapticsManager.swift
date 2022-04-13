//
//  HapticsManager.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 03.04.2022.
//

import UIKit

/// Object to manage haptics
final class HapticsManager {
  /// Singleton
  static let shared = HapticsManager()
  private init() {}
  
  // MARK: Public
  
  /// Vibrate slightly fo selection
  public func vibrateForSelection() {
    // light vibration
  }
}
