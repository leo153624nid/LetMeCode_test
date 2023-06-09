//
//  ApiCaller.swift
//  LetMeCode_test
//
//  Created by macbook on 05.04.2023.
//

import Foundation

// MARK: - APICallerProtocol
protocol APICallerProtocol {
    var urlInfo: UrlInfoProtocol { get set }
    
    func getReviewes(completion: @escaping (Result<[Review], Error>) -> Void)
    func searchReviewes(with query: String,
                     completion: @escaping (Result<[Review], Error>) -> Void)
    
    func getCritics(completion: @escaping (Result<[Critic], Error>) -> Void)
    func searchCritics(with query: String,
                     completion: @escaping (Result<[Critic], Error>) -> Void)
    
    func getCriticReviewes(completion: @escaping (Result<[Review], Error>) -> Void)
}

// MARK: - UrlInfoProtocol
protocol UrlInfoProtocol {
    var currentURL: URL? { get set }
    var limit: Int { get set }
    var offset: Int { get set }
    var page: Int { get set }
    var apiKey: String { get set }
    
    func getReviewesNextPageURL() -> URL?
    func getReviewesSearchURL(with query: String) -> URL?
    
    func getCriticsURL() -> URL?
    func getCriticsSearchURL(with query: String) -> URL?
    
    func getCriticReviewesNextPageURL() -> URL?
}

// MARK: - UrlInfo
final class UrlInfo: UrlInfoProtocol {
    // MARK: - Reviewes base urls
    static let reviewesPicks = "https://api.nytimes.com/svc/movies/v2/reviews/picks.json"
    static let searchReviewes = "https://api.nytimes.com/svc/movies/v2/reviews/search.json?query="
    
    // MARK: - Critics base urls
    static let criticsAll = "https://api.nytimes.com/svc/movies/v2/critics/all.json"
    static let searchCritics = "https://api.nytimes.com/svc/movies/v2/critics/"
    
    // MARK: - params
    var currentURL: URL?
    var searchURL: URL?
    var limit = 20
    var offset = 0
    var page = 1
    var apiKey: String
    
    init(apiKey: String) {
        self.currentURL = URL(string: "\(UrlInfo.reviewesPicks)?api-key=\(apiKey)")
        self.apiKey = apiKey
    }
    
    // MARK: - Reviewes Module
    func getReviewesNextPageURL() -> URL? {
        guard let url = URL(string:  "\(UrlInfo.reviewesPicks)?api-key=\(apiKey)&offset=\(offset)") else { return nil }
        self.currentURL = url
        self.page += 1
        self.offset = page * limit
        
        return self.currentURL
    }
    func getReviewesSearchURL(with query: String) -> URL? {
        guard let url = URL(string: "\(UrlInfo.searchReviewes)\(query)&api-key=\(apiKey)") else { return nil }
        self.searchURL = url
        
        return self.searchURL
    }
    
    // MARK: - Critics Module
    func getCriticsURL() -> URL? {
        guard let url = URL(string: "\(UrlInfo.criticsAll)?api-key=\(apiKey)") else { return nil }
        self.currentURL = url
        
        return self.currentURL
    }
    func getCriticsSearchURL(with query: String) -> URL? {
        guard let url = URL(string: "\(UrlInfo.searchCritics)\(query).json?api-key=\(apiKey)") else { return nil }
        self.searchURL = url
        
        return self.searchURL
    }
    
    // MARK: - Person Module
    func getCriticReviewesNextPageURL() -> URL? {
        guard let url = URL(string:  "\(UrlInfo.reviewesPicks)?api-key=\(apiKey)&offset=\(offset)") else { return nil }
        self.currentURL = url
        self.page += 1
        self.offset = page * limit
        
        return self.currentURL
    }
}

// MARK: - APICaller
final class APICaller: APICallerProtocol {
    static let shared: APICallerProtocol = APICaller()
    var urlInfo: UrlInfoProtocol = UrlInfo(apiKey: "2hdD7Tro9byozENHGHJ8YukOw7W5lZCt")
    
    private init() {}
    
    // MARK: - Reviewes Module
    public func getReviewes(completion: @escaping (Result<[Review], Error>) -> Void) {
        guard let url = urlInfo.getReviewesNextPageURL() else { return }
        print("next page = \(urlInfo.page)")
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(ReviewesAPIResponse.self, from: data)
                    completion(.success(result.results))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    public func searchReviewes(with query: String,
                            completion: @escaping (Result<[Review], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        guard let url = urlInfo.getReviewesSearchURL(with: query) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(ReviewesAPIResponse.self, from: data)
                    completion(.success(result.results))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Critics Module
    public func getCritics(completion: @escaping (Result<[Critic], Error>) -> Void) {
        guard let url = urlInfo.getCriticsURL() else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(CriticsAPIResponse.self, from: data)
                    completion(.success(result.results))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    public func searchCritics(with query: String,
                            completion: @escaping (Result<[Critic], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        guard let url = urlInfo.getCriticsSearchURL(with: query) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(CriticsAPIResponse.self, from: data)
                    completion(.success(result.results))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Person Module
    public func getCriticReviewes(completion: @escaping (Result<[Review], Error>) -> Void) {
        guard let url = urlInfo.getCriticReviewesNextPageURL() else { return }
        print("next page = \(urlInfo.page)")
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(ReviewesAPIResponse.self, from: data)
                    completion(.success(result.results))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
