//
//  PersonInteractor.swift
//  LetMeCode_test
//
//  Created by macbook on 09.04.2023.
//

import Foundation

protocol PersonInteractorProtocol: AnyObject {
    func loadReviewes(pagination: Bool)
    func refreshReviewes()
}

class PersonInteractor: PersonInteractorProtocol {
    weak var presenter: PersonPresenterProtocol?
    private var apiCaller: APICallerProtocol
    
    private var reviewes = [Review]()
    
    init(with service: APICallerProtocol) {
        self.apiCaller = service
    }
    
    func loadReviewes(pagination: Bool) { // todo
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
    
    func refreshReviewes() { // todo
        apiCaller.urlInfo.offset = 0
        apiCaller.urlInfo.page = 1
        loadReviewes(pagination: false)
    }
}
