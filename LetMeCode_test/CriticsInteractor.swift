//
//  CriticsInteractor.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import Foundation

protocol CriticsInteractorProtocol: AnyObject {
    func loadCritics(pagination: Bool)
    func refreshCritics()
    func searchCritics(with query: String)
}

class CriticsInteractor: CriticsInteractorProtocol {
    weak var presenter: CriticsPresenterProtocol?
    private var apiCaller: APICallerProtocol
    
    private var critics = [Critic]() 
    private var query = ""
    
    init(with service: APICallerProtocol) {
        self.apiCaller = service
        self.apiCaller.urlInfo.offset = 0
        self.apiCaller.urlInfo.page = 1
    }
    
    func loadCritics(pagination: Bool) {
        apiCaller.getCritics() { [weak self] result in
            switch result {
                case .success(let data):
                    if pagination {
                        self?.critics.append(contentsOf: data)
                    } else {
                        self?.critics = data
                    }
                    self?.presenter?.isPaginating = false
                    self?.presenter?.didLoad(critics: self?.critics ?? [Critic]())
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.presenter?.isPaginating = false
                    self?.presenter?.didLoad(critics: self?.critics ?? [Critic]())
            }
        }
    }
    
    func refreshCritics() {
        apiCaller.urlInfo.offset = 0
        apiCaller.urlInfo.page = 1
        loadCritics(pagination: false)
    }
    
    func searchCritics(with query: String) {
        apiCaller.searchCritics(with: query) { [weak self] result in
            self?.query = query
            switch result {
                case .success(let data):
                    self?.critics = data
                    self?.presenter?.didLoad(critics: self?.critics ?? [Critic]())
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.presenter?.didLoad(critics: [Critic]())
            }
        }
    }
}
