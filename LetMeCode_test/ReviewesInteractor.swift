//
//  ReviewesInteractor.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import Foundation

protocol ReviewesInteractorProtocol: AnyObject {
    func loadReviewes()
}

class ReviewesInteractor: ReviewesInteractorProtocol {

    weak var presenter: ReviewesPresenterProtocol?
    private var apiCaller: APICallerProtocol
    
    init(with service: APICallerProtocol) {
        self.apiCaller = service
    }
    
    func loadReviewes() {
        apiCaller.getReviewes(pagination: false) { [weak self] result in
            switch result {
                case .success(let data):
                    self?.presenter?.didLoad(reviewes: data.description) // todo
//                    self?.articles.append(contentsOf: articles)
//                    print("articles: \(String(describing: self?.articles.count))")
//                    self?.viewModels.append(contentsOf: articles.compactMap({
//                        NewsTableViewCellViewModel(title: $0.title,
//                                                   subtitle: $0.description ?? "-",
//                                                   imageURL: URL(string: $0.urlToImage ?? ""))
//                    }))
//
//                    DispatchQueue.main.async {
//                        self?.tableView.reloadData()
//                    }
                case .failure(let error): print(error.localizedDescription)
            }
        }
    }
    
    
}


