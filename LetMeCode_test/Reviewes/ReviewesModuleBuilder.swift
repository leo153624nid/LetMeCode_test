//
//  ReviewesModuleBuilder.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import Foundation
import UIKit

class ReviewesModuleBuilder {
    static func build() -> ReviewesViewController {
        
        let interactor = ReviewesInteractor(with: APICaller.shared)
        let router = ReviewesRouter()
        let presenter = ReviewesPresenter(router: router, interactor: interactor)
        let viewController = ReviewesViewController()
        
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
}
