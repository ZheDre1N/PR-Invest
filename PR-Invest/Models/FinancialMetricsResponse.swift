//
//  FinancialMetricsResponse.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 11.04.2022.
//

import Foundation

struct FinancialMetricsResponse: Codable {
  let metric: Metrics
}

struct Metrics: Codable {
  let TenDayAverageTradingVolume: Float
  let AnnualHigh: Double
  let AnnualLow: Double
  let AnnualLowDate: String
  let AnnualPriceReturnDaily: Float
  let beta: Float

  enum CodingKeys: String, CodingKey {
    case TenDayAverageTradingVolume = "10DayAverageTradingVolume"
    case AnnualHigh = "52WeekHigh"
    case AnnualLow = "52WeekLow"
    case AnnualLowDate = "52WeekLowDate"
    case AnnualPriceReturnDaily = "52WeekPriceReturnDaily"
    case beta = "beta"
  }
}
