//
//  CriticsPresenter.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import Foundation

protocol CriticsPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func didLoad(critics: String?) // todo
    func reviewesButtonTapped()
}

class CriticsPresenter {
    weak var view: CriticsViewProtocol?
    var router: CriticsRouterProtocol
    var interactor: CriticsInteractorProtocol
    
    init(router: CriticsRouterProtocol, interactor: CriticsInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
   
    
}

extension CriticsPresenter: CriticsPresenterProtocol {
    func viewDidLoaded() {
        interactor.loadCritics()
    }
    
    func didLoad(critics: String?) {
        view?.showCritics(critics: critics ?? "no data")
    }
    
    func reviewesButtonTapped() {
        router.openReviewes()
    }
    
    
}
