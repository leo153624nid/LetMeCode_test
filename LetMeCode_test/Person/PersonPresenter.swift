//
//  PersonPresenter.swift
//  LetMeCode_test
//
//  Created by macbook on 09.04.2023.
//

import Foundation

protocol PersonPresenterProtocol: AnyObject {
    var isPaginating: Bool { get set }
    
    func viewDidLoaded()
    func refresh()
    func loadMore()
    
    func didLoad(reviewes: [Review])
    func criticsButtonTapped()
}

class PersonPresenter {
    weak var view: PersonViewProtocol?
    var router: PersonRouterProtocol
    var interactor: PersonInteractorProtocol
    
    var articles = [ReviewesTableViewCellViewModel]() // todo
    var isPaginating = false
    
    init(router: PersonRouterProtocol, interactor: PersonInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
}

extension PersonPresenter: PersonPresenterProtocol {
    func viewDidLoaded() {
        interactor.loadReviewes(pagination: isPaginating)
    }
    
    func refresh() {
        isPaginating = false
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
        interactor.loadReviewes(pagination: isPaginating)
    }
    
    func criticsButtonTapped() {
        router.openCritics()
    }
}
