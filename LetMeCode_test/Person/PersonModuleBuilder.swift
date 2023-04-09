//
//  PersonModuleBuilder.swift
//  LetMeCode_test
//
//  Created by macbook on 09.04.2023.
//

import Foundation
import UIKit

class PersonModuleBuilder {
    static func build(with data: CriticsCollectionViewCellViewModel) -> PersonViewController {
        let interactor = PersonInteractor(with: APICaller.shared, person: data)
        let router = PersonRouter()
        let presenter = PersonPresenter(router: router, interactor: interactor)
        let viewController = PersonViewController()
        
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
}
