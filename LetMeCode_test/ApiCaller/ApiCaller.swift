//
//  ApiCaller.swift
//  LetMeCode_test
//
//  Created by macbook on 05.04.2023.
//

import Foundation

protocol APICallerProtocol {
    var urlInfo: UrlInfoProtocol { get }
    var isPaginating: Bool { get set }
    
    func getReviewes(pagination: Bool,
                     completion: @escaping (Result<[Review], Error>) -> Void)
}

protocol UrlInfoProtocol {
    var currentURL: URL? { get set }
    var limit: Int { get set }
    var offset: Int { get set }
    var page: Int { get set }
    var apiKey: String { get set }
    
    func getReviewesNextPageURL() -> URL?
}

final class UrlInfo: UrlInfoProtocol {
    var currentURL: URL?
    var limit = 20 // do you need it??
    var offset = 0
    var page = 1
    var apiKey: String
    
    init(apiKey: String) {
        self.currentURL = URL(string: "https://api.nytimes.com/svc/movies/v2/reviews/picks.json?api-key=\(apiKey)")
        self.apiKey = apiKey
    }
    
    func getReviewesNextPageURL() -> URL? {
        guard let url = URL(string:  "https://api.nytimes.com/svc/movies/v2/reviews/picks.json?api-key=\(apiKey)&offset=\(offset)&limit=\(limit)") else { return nil }
        self.currentURL = url
        self.page += 1
        self.offset = page * limit
        
        return self.currentURL
    }
}

final class APICaller: APICallerProtocol {
    static let shared: APICallerProtocol = APICaller()
    let urlInfo: UrlInfoProtocol = UrlInfo(apiKey: "2hdD7Tro9byozENHGHJ8YukOw7W5lZCt")
    var isPaginating = false
    
    private init() {}
    
    public func getReviewes(pagination: Bool = false,
                            completion: @escaping (Result<[Review], Error>) -> Void) {
        if pagination {
            isPaginating = true
        }
        guard let url = urlInfo.getReviewesNextPageURL() else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                if pagination {
                    self.isPaginating = false
                }
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(ReviewesAPIResponse.self, from: data)
                    completion(.success(result.results))
                    if pagination {
                        self.isPaginating = false
                    }
                } catch {
                    completion(.failure(error))
                    if pagination {
                        self.isPaginating = false
                    }
                }
            }
        }
        task.resume()
        
    }
}
