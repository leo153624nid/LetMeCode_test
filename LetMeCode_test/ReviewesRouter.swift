//
//  ReviewesRouter.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import Foundation

protocol ReviewesRouterProtocol: AnyObject {
    func openCritics()
}

class ReviewesRouter: ReviewesRouterProtocol {
    
    weak var viewController: ReviewesViewController?
    
    func openCritics() {
        let vc = CriticsModuleBuilder.build()
//        viewController?.present(vc, animated: true, completion: nil)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
}


