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
    
    var articles = [CriticsCollectionViewCellViewModel]()
    var isPaginating = false
    
    init(router: CriticsRouterProtocol,
         interactor: CriticsInteractorProtocol) {
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
            articles = [CriticsCollectionViewCellViewModel]()
        }
        articles.append(contentsOf: critics.compactMap({
            CriticsCollectionViewCellViewModel(
                title: $0.displayName,
                status: $0.status.rawValue,
                imageURL: URL(string: ($0.multimedia?.resource.src) ?? ""),
                bio: $0.bio
            )
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
