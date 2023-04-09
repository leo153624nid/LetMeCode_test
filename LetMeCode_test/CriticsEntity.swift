//
//  CriticsEntity.swift
//  LetMeCode_test
//
//  Created by macbook on 09.04.2023.
//

import Foundation

// MARK: - CriticsAPIResponse
struct CriticsAPIResponse: Codable {
    let status, copyright: String
    let numResults: Int
    let results: [Critic]
    
    enum CodingKeys: String, CodingKey {
        case status, copyright
        case numResults = "num_results"
        case results
    }
}

// MARK: - Critic
struct Critic: Codable {
    let displayName, sortName: String
    let status: Status
    let bio, seoName: String
    let multimedia: MultimediaCritics?

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case sortName = "sort_name"
        case status, bio
        case seoName = "seo_name"
        case multimedia
    }
}

// MARK: - MultimediaCritics
struct MultimediaCritics: Codable {
    let resource: Resource
}

// MARK: - Resource
struct Resource: Codable {
    let type: String
    let src: String
    let height, width: Int
    let credit: String
}

enum Status: String, Codable {
    case empty = ""
    case fullTime = "full-time"
    case partTime = "part-time"
}

// MARK: - CriticsCollectionViewCellViewModel
class CriticsCollectionViewCellViewModel { // todo
    let title: String
    let status: String?
    let imageURL: URL?
    var imageData: Data? = nil
    let bio: String?
    
    init(title: String,
         status: String?,
         imageURL: URL?,
         bio: String?
    ) {
        self.title = title
        self.status = status
        self.imageURL = imageURL
        self.bio = bio
    }
}
