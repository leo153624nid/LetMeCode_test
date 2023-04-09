//
//  CriticsPresenter.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import Foundation

protocol CriticsPresenterProtocol: AnyObject {
    var isPaginating: Bool { get set }
    
    func viewDidLoaded()
    func refresh()
    func loadMore()
    
    func didLoad(critics: [Critic]) 
    func reviewesButtonTapped()
    
    func search(with query: String)
}

class CriticsPresenter {
    weak var view: CriticsViewProtocol?
    var router: CriticsRouterProtocol
    var interactor: CriticsInteractorProtocol
    
    var articles = [ReviewesTableViewCellViewModel]() // todo
    var isPaginating = false
    
    init(router: CriticsRouterProtocol, interactor: CriticsInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
}

extension CriticsPresenter: CriticsPresenterProtocol {
    func viewDidLoaded() {
        interactor.loadCritics(pagination: isPaginating)
    }
    
    func refresh() {
        isPaginating = false
        interactor.refreshCritics()
    }
    
    func didLoad(critics: [Critic]) {
        if !isPaginating {
            articles = [ReviewesTableViewCellViewModel]() // todo
        }
        articles.append(contentsOf: critics.compactMap({
            ReviewesTableViewCellViewModel(title: $0.displayTitle,
                                           subtitle: $0.summaryShort,
                                           imageURL: URL(string: $0.multimedia.src),
                                           linkURL: URL(string: $0.link.url),
                                           byline: $0.byline,
                                           publicationDate: $0.publicationDate)
        }))
        view?.showCritics(articles: articles)
    }
    
    func loadMore() {
        isPaginating = true
        interactor.loadCritics(pagination: isPaginating)
    }
    
    func reviewesButtonTapped() {
        router.openReviewes()
    }
    
    func search(with query: String) {
        isPaginating = false
        interactor.searchCritics(with: query)
    }
    
    
}
