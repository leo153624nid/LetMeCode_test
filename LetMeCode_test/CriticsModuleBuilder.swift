//
//  CriticsModuleBuilder.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import Foundation
import UIKit

class CriticsModuleBuilder {
    static func build() -> UIViewController {
        
        let interactor = CriticsInteractor(with: APICaller.shared)
        let router = CriticsRouter()
        let presenter = CriticsPresenter(router: router, interactor: interactor)
        let viewController = CriticsViewController()

        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
}
