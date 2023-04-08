//
//  ReviewesInteractor.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import Foundation

protocol ReviewesInteractorProtocol: AnyObject {
    func loadReviewes()
}

class ReviewesInteractor: ReviewesInteractorProtocol {

    weak var presenter: ReviewesPresenterProtocol?
    private var apiCaller: APICallerProtocol
    
    private var reviewes = [Review]()
    
    init(with service: APICallerProtocol) {
        self.apiCaller = service
    }
    
    func loadReviewes() {
        apiCaller.getReviewes(pagination: false) { [weak self] result in
            switch result {
                case .success(let data):
                    self?.reviewes.append(contentsOf: data)
                    self?.presenter?.didLoad(reviewes: data)
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.presenter?.didLoad(reviewes: self?.reviewes ?? [Review]())
            }
        }
    }
    
    
}


