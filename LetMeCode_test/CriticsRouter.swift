//
//  CriticsRouter.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import Foundation

protocol CriticsRouterProtocol: AnyObject {
    func openReviewes()
}

class CriticsRouter: CriticsRouterProtocol {
    weak var viewController: CriticsViewController?
    
    func openReviewes() {
        // вернуться на прошлый экран, а не создавать новый
//        let vc = ReviewesModuleBuilder.build()
//        viewController?.present(vc, animated: true, completion: nil)
    }
}
