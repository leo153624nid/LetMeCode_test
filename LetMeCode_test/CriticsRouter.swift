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
        viewController?.navigationController?.dismiss(animated: true, completion: nil)
    }
}
