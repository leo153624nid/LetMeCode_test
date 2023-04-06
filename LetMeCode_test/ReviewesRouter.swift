//
//  ReviewesRouter.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import Foundation

protocol ReviewesRouterProtocol: AnyObject {
    
}

class ReviewesRouter {
    weak var presenter: ReviewesPresenterProtocol?
}

extension ReviewesRouter: ReviewesRouterProtocol {
    
}
