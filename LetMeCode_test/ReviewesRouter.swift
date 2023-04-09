//
//  ReviewesRouter.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import Foundation
import UIKit

protocol ReviewesRouterProtocol: AnyObject {
    func openCritics()
}

class ReviewesRouter: ReviewesRouterProtocol {
    
    weak var viewController: ReviewesViewController?
    
    func openCritics() {
        let criticsVC = CriticsModuleBuilder.build()
        let navController = UINavigationController(rootViewController: criticsVC)
        navController.modalPresentationStyle = .fullScreen
        viewController?.present(navController, animated: true, completion: nil)
//        viewController?.navigationController?.pushViewController(navController, animated: true)
    }
    
}


