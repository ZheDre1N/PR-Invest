//
//  SearchResponse.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 04.04.2022.
//

import Foundation

struct SearchResponse: Codable {
  let count: Int
  let result: [SearchResult]
}

struct SearchResult: Codable {
  let description: String
  let displaySymbol: String
  let symbol: String
  let type: String
}
