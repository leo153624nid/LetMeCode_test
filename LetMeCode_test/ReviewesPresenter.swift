//
//  ReviewesPresenter.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import Foundation

protocol ReviewesPresenterProtocol: AnyObject {
    var isPaginating: Bool { get set }
    var isFilter: Bool { get set }
    
    func viewDidLoaded()
    func refresh()
    func loadMore()
    
    func didLoad(reviewes: [Review])
    func criticsButtonTapped()
    
    func search(with query: String)
    func filter(by textDate: String)
}

class ReviewesPresenter {
    weak var view: ReviewesViewProtocol?
    var router: ReviewesRouterProtocol
    var interactor: ReviewesInteractorProtocol
    
    var articles = [ReviewesTableViewCellViewModel]()
    var isPaginating = false
    var isFilter = false
    
    init(router: ReviewesRouterProtocol, interactor: ReviewesInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
}

extension ReviewesPresenter: ReviewesPresenterProtocol {
    func viewDidLoaded() {
        interactor.loadReviewes(pagination: isPaginating)
    }
    
    func refresh() {
        isPaginating = false
        isFilter = false
        interactor.refreshReviewes()
    }
    
    func didLoad(reviewes: [Review]) {
        if !isPaginating {
            articles = [ReviewesTableViewCellViewModel]() // !!!!! обнуление данных
        }
        articles.append(contentsOf: reviewes.compactMap({
            ReviewesTableViewCellViewModel(title: $0.displayTitle,
                                           subtitle: $0.summaryShort,
                                           imageURL: URL(string: $0.multimedia.src),
                                           linkURL: URL(string: $0.link.url),
                                           byline: $0.byline,
                                           publicationDate: $0.publicationDate)
        }))
        view?.showReviewes(articles: articles)
    }
    
    func loadMore() {
        isPaginating = true
        isFilter = false
        interactor.loadReviewes(pagination: isPaginating) 
    }
    
    func criticsButtonTapped() {
        router.openCritics()
    }
    
    func search(with query: String) {
        isPaginating = false
        isFilter = false
        interactor.searchReviewes(with: query)
    }
    
    func filter(by textDate: String) {
        isFilter = true
        let filterArray = articles.filter { $0.publicationDate == textDate } 
        view?.showReviewes(articles: filterArray)
    }
}
