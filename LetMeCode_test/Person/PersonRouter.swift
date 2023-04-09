//
//  PersonRouter.swift
//  LetMeCode_test
//
//  Created by macbook on 09.04.2023.
//

import Foundation
import UIKit

protocol PersonRouterProtocol: AnyObject {
    func openCritics()
}

class PersonRouter: PersonRouterProtocol {
    
    weak var viewController: PersonViewController?
    
    func openCritics() {
        viewController?.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
