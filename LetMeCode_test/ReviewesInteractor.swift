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
//        super.init(nibName: nil, bundle: nil)
    }
    
//    required init?(coder: NSCoder) {
//        self.apiCaller = APICaller.shared
//        super.init(coder: coder)
//    }
    
    func loadReviewes() {
        
    }
    
    
}


