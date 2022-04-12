//
//  APICaller.swift
//  PR-Invest
//
//  Created by Eugene Dudkin on 03.04.2022.
//

import Foundation

final class APICaller {
  static let shared = APICaller()
  
  private init() {}
  
  // MARK: Public
  
  public func search(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
    
    guard let safeQuery = query.addingPercentEncoding(
      withAllowedCharacters: .urlQueryAllowed
    ) else {
      return
    }

    request(
      url: url(for: .search,queryParams: ["q": safeQuery]),
      expecting: SearchResponse.self,
      completion: completion
    )
  }
  
  // get stock info
  
  public func news(
    for type: NewsViewController.NewsType,
    completion: @escaping (Result<[NewsStory], Error>) ->  Void
  ) {
    
    switch type {
    case .topStories :
      request(
        url:
          url(
            for: .topStories,
            queryParams: ["category": "general"]
          ),
        expecting: [NewsStory].self,
        completion: completion
      )
    case .company(let ticker):
      let today = Date()
      let oneWeekAgo = today.addingTimeInterval(-(3600 * 24 * 7))
      
      request(
        url: url(
          for: .companyNews,
          queryParams: [
            "symbol": ticker,
            "from": DateFormatter.newsDateFormatter.string(from: oneWeekAgo),
            "to": DateFormatter.newsDateFormatter.string(from: today)
          ]
        ),
        expecting: [NewsStory].self,
        completion: completion
      )
    }
  }
  
  // search stocks
  public func marketData(
    for symbol: String,
    numberOfDays: TimeInterval = 7,
    completion: @escaping(Result<MarketDataResponse, Error>) -> Void
  ) {
    let today = Date().addingTimeInterval(-(3600 * 24))
    let prior = today.addingTimeInterval(-(3600 * 24 * numberOfDays))
    
    let url = url(
      for: .marketData,
      queryParams: [
        "symbol": symbol,
        "resolution": "1",
        "from": "\(Int(prior.timeIntervalSince1970))",
        "to": "\(Int(today.timeIntervalSince1970))"
      ]
    )
    
    request(url: url, expecting: MarketDataResponse.self, completion: completion)
  }
  
  public func financialMetrics(
    for symbol: String,
    completion: @escaping (Result<FinancialMetricsResponse, Error>) -> Void
  ) {
    let url = url(
      for: .financials,
      queryParams: ["symbol": symbol, "metric": "all"]
    )
    
    request(
      url: url,
      expecting: FinancialMetricsResponse.self,
      completion: completion
    )
  }
  
  // MARK: Private
  
  private enum Constants {
    static let apiKey = "c95b8gqad3icae7g81cg"
    static let sandboxAPIKey = "sandbox_c95b8gqad3icae7g81d0"
    static let baseURL = "https://finnhub.io/api/v1/"
  }
  
  private enum Endpoint: String {
    case search
    case topStories = "news"
    case companyNews = "company-news"
    case marketData = "stock/candle"
    case financials = "stock/metric"
  }
  
  private enum APIError: Error {
    case invalidURL
    case noDataReturned
  }
  
  private func url(for endpoint: Endpoint, queryParams: [String: String] = [:]) -> URL? {
    var urlString = Constants.baseURL + endpoint.rawValue
    
    var queryItems = [URLQueryItem]()
    // add any params
    for (name, value) in queryParams {
      queryItems.append(.init(name: name, value: value))
    }
    
    // add token
    queryItems.append(.init(name: "token", value: Constants.apiKey))
    
    // Convert queri items to suffix string
    urlString += "?" + queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
    
    
    return URL(string: urlString)
  }
  
  private func request<T: Codable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
    guard let url = url else {
      completion(.failure(APIError.invalidURL))
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
      guard let data = data, error == nil else {
        if let error = error {
          completion(.failure(error))
        } else {
          completion(.failure(APIError.noDataReturned))
        }
        return
      }

      do {
        let result = try JSONDecoder().decode(expecting, from: data)
        completion(.success(result))
      } catch {
        completion(.failure(error))
      }
      
    }
    task.resume()
  }
}
