//
//  ReviewesPresenter.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import Foundation

protocol ReviewesPresenterProtocol: AnyObject {
    var isPaginating: Bool { get set }
    func viewDidLoaded()
    func loadMore()
    func didLoad(reviewes: [Review])
    func criticsButtonTapped()
}

class ReviewesPresenter {
    weak var view: ReviewesViewProtocol?
    var router: ReviewesRouterProtocol
    var interactor: ReviewesInteractorProtocol
    
    var isPaginating = true
    
    init(router: ReviewesRouterProtocol, interactor: ReviewesInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
}

extension ReviewesPresenter: ReviewesPresenterProtocol {
    func viewDidLoaded() {
        // start loading data
        interactor.loadReviewes(pagination: isPaginating)
    }
    
    func didLoad(reviewes: [Review]) {
        var articles = [ReviewesTableViewCellViewModel]()
        
        articles.append(contentsOf: reviewes.compactMap({
            ReviewesTableViewCellViewModel(title: $0.displayTitle,
                                           subtitle: $0.summaryShort,
                                           imageURL: URL(string: $0.multimedia.src),
                                           linkURL: URL(string: $0.link.url),
                                           byline: $0.byline,
                                           updatedDate: $0.dateUpdated)
        }))
        view?.showReviewes(articles: articles)
    }
    
    func loadMore() {
        isPaginating = true
        interactor.loadReviewes(pagination: isPaginating) 
    }
    
    func criticsButtonTapped() {
        router.openCritics()
    }
}
