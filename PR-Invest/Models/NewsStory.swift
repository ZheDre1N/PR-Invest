//
//  NewsStory.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 05.04.2022.
//

import Foundation

struct NewsStory: Codable {
  let category: String
  let datetime: TimeInterval
  let headline: String
  let image: String
  let related: String
  let source: String
  let summary: String
  let url: String
}
