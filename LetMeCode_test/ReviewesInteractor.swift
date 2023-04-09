//
//  ReviewesInteractor.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import Foundation

protocol ReviewesInteractorProtocol: AnyObject {
    func loadReviewes(pagination: Bool)
    func refreshReviewes()
    func searchReviewes(with query: String)
}

class ReviewesInteractor: ReviewesInteractorProtocol {
    weak var presenter: ReviewesPresenterProtocol?
    private var apiCaller: APICallerProtocol
    
    private var reviewes = [Review]()
    private var query = ""
    
    init(with service: APICallerProtocol) {
        self.apiCaller = service
    }
    
    func loadReviewes(pagination: Bool) {
        apiCaller.getReviewes() { [weak self] result in
            switch result {
                case .success(let data):
                    if pagination {
                        self?.reviewes.append(contentsOf: data)
                    } else {
                        self?.reviewes = data
                    }
                    self?.presenter?.isPaginating = false
                    self?.presenter?.didLoad(reviewes: self?.reviewes ?? [Review]())
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.presenter?.isPaginating = false
                    self?.presenter?.didLoad(reviewes: self?.reviewes ?? [Review]())
            }
        }
    }
    
    func refreshReviewes() {
        apiCaller.urlInfo.offset = 0
        apiCaller.urlInfo.page = 1
        loadReviewes(pagination: false)
    }
    
    func searchReviewes(with query: String) {
        apiCaller.searchReviewes(with: query) { [weak self] result in
            self?.query = query
            switch result {
                case .success(let data):
                    self?.reviewes = data
                    self?.presenter?.didLoad(reviewes: self?.reviewes ?? [Review]())
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.presenter?.didLoad(reviewes: [Review]())
            }
        }
    } 
}


