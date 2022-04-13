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
  let generator = UISelectionFeedbackGenerator()
    generator.prepare()
    generator.selectionChanged()
  }
  
  /// Play haptics for given type interaction
  /// - Parameter type: Type to vibrate
  public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
      generator.prepare()
      generator.notificationOccurred(type)
  }
}
