//
//  PersonInteractor.swift
//  LetMeCode_test
//
//  Created by macbook on 09.04.2023.
//

import Foundation

protocol PersonInteractorProtocol: AnyObject {
    func loadCriticReviewes(pagination: Bool)
    func refreshCriticReviewes()
}

class PersonInteractor: PersonInteractorProtocol {
    weak var presenter: PersonPresenterProtocol?
    private var apiCaller: APICallerProtocol
    
    private var person: CriticsCollectionViewCellViewModel!
    private var reviewes = [Review]()
    
    init(with service: APICallerProtocol, person: CriticsCollectionViewCellViewModel) {
        self.apiCaller = service
        self.person = person
        self.apiCaller.urlInfo.offset = 0
        self.apiCaller.urlInfo.page = 1
    }
    
    // MARK: - loadCriticReviewes
    func loadCriticReviewes(pagination: Bool) {
        presenter?.person = person
        
        apiCaller.getCriticReviewes() { [weak self] result in
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
    
    // MARK: - refreshCriticReviewes
    func refreshCriticReviewes() {
        apiCaller.urlInfo.offset = 0
        apiCaller.urlInfo.page = 1
        loadCriticReviewes(pagination: false)
    }
}
