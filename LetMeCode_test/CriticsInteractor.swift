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
    private var page = 1
    private var limit = 10
    private var query = ""
    
    init(with service: APICallerProtocol) {
        self.apiCaller = service
        self.apiCaller.urlInfo.offset = 0
        self.apiCaller.urlInfo.page = 1
    }
    
    func loadCritics(pagination: Bool) {
        switch pagination {
            case true:
                let criticsPageArray = self.getSubArray(page: self.page, limit: self.limit)
                self.presenter?.didLoad(critics: criticsPageArray)
                self.page += 1
            case false:
                apiCaller.getCritics() { [weak self] result in
                    switch result {
                        case .success(let data):
                            self?.critics = data
                            self?.presenter?.isPaginating = false
                            let criticsPageArray = self?.getSubArray(page: self?.page ?? 1, limit: self?.limit ?? 10)
                            self?.presenter?.didLoad(critics: criticsPageArray ?? [Critic]())
                            self?.page += 1
                        case .failure(let error):
                            print(error.localizedDescription)
                            self?.presenter?.isPaginating = false
                            self?.presenter?.didLoad(critics: self?.critics ?? [Critic]())
                    }
                }
        }
    }
    
    func refreshCritics() {
        limit = 10
        page = 1
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
    
//    private func getSubArray<T>(array: [T], page: Int, limit: Int) -> [T] {
//        var newArray = [T]()
//        for (index, value) in array.enumerated() {
//            if index >= (page * limit - limit) && index < (page * limit) {
//                newArray.append(value)
//            }
//        }
//        return newArray
//    }
    private func getSubArray(page: Int, limit: Int) -> [Critic] {
        var newArray = [Critic]()
        for (index, value) in self.critics.enumerated() {
            if index >= (page * limit - limit) && index < (page * limit) {
                newArray.append(value)
            }
        }
        return newArray
    }
}
