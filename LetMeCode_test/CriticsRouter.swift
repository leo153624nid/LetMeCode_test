//
//  CriticsRouter.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import Foundation

protocol CriticsRouterProtocol: AnyObject {
    func openReviewes()
    func openPerson(with data: CriticsCollectionViewCellViewModel)
}

class CriticsRouter: CriticsRouterProtocol {
    weak var viewController: CriticsViewController?
    
    func openReviewes() {
        viewController?.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func openPerson(with data: CriticsCollectionViewCellViewModel) {
        let personVC = PersonModuleBuilder.build(with: data)

        viewController?.navigationController?.pushViewController(personVC, animated: true)
    }
}
