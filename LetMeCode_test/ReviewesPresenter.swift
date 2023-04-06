//
//  ReviewesPresenter.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import Foundation

protocol ReviewesPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func didLoad(reviewes: String?) // todo
}

class ReviewesPresenter {
    weak var view: ReviewesViewProtocol?
    var router: ReviewesRouterProtocol
    var interactor: ReviewesInteractorProtocol
    
    init(router: ReviewesRouterProtocol, interactor: ReviewesInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
}

extension ReviewesPresenter: ReviewesPresenterProtocol {
    func viewDidLoaded() {
        // start loading data
        interactor.loadReviewes()
    }
    
    func didLoad(reviewes: String?) { // todo
        view?.showReviewes(reviewes: reviewes ?? "no data")
    }
}
