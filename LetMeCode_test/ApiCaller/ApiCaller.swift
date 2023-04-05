//
//  ApiCaller.swift
//  LetMeCode_test
//
//  Created by macbook on 05.04.2023.
//

import Foundation

final class UrlInfo: UrlInfoProtocol {
    var currentURL: URL?
    var pageSize = 6
    var page = 1
    var apiKey: String
    
    init(apiKey: String) {
        self.currentURL = URL(string: "https://newsapi.org/v2/everything?q=Apple&pageSize=\(pageSize)&page=\(page)&apiKey=\(apiKey)")
        self.apiKey = apiKey
    }
    
    func getNextPageURL() -> URL? {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=Apple&pageSize=\(pageSize)&page=\(page)&apiKey=\(apiKey)") else { return nil }
        self.currentURL = url
        self.page += 1
        return self.currentURL
    }
}

final class APICaller: APICallerProtocol {
    static let shared: APICallerProtocol = APICaller()
    let urlInfo: UrlInfoProtocol = UrlInfo(apiKey: "b505953bf7614254a430c1a8bdea8e6a")
    var isPaginating = false
    
    private init() {}
    
    public func getTopStories(pagination: Bool = false,
                              completion: @escaping (Result<[Article], Error>) -> Void) {
        if pagination {
            isPaginating = true
        }
        guard let url = urlInfo.getNextPageURL() else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                if pagination {
                    self.isPaginating = false
                }
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
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
