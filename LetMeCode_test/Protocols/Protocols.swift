//
//  Protocols.swift
//  LetMeCode_test
//
//  Created by macbook on 05.04.2023.
//

import Foundation

protocol APICallerProtocol {
    var urlInfo: UrlInfoProtocol { get }
    var isPaginating: Bool { get set }
    
    func getReviewes(pagination: Bool,
                     completion: @escaping (Result<[Article], Error>) -> Void)
}

protocol UrlInfoProtocol {
    var currentURL: URL? { get set }
    var pageSize: Int { get set }
    var page: Int { get set }
    var apiKey: String { get set }
    
    func getNextPageURL() -> URL?
}
