//
//  ReviewesInteractor.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import Foundation

protocol ReviewesInteractorProtocol: AnyObject {
    func loadReviewes(pagination: Bool)
}

class ReviewesInteractor: ReviewesInteractorProtocol {

    weak var presenter: ReviewesPresenterProtocol?
    private var apiCaller: APICallerProtocol
    
    private var reviewes = [Review]()
    
    init(with service: APICallerProtocol) {
        self.apiCaller = service
    }
    
    func loadReviewes(pagination: Bool) {
        apiCaller.getReviewes(pagination: pagination) { [weak self] result in
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
    
    
}


