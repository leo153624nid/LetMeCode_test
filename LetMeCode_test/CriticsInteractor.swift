//
//  CriticsInteractor.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import Foundation

protocol CriticsInteractorProtocol: AnyObject {
    func loadCritics()
}

class CriticsInteractor: CriticsInteractorProtocol {
    weak var presenter: CriticsPresenterProtocol?
    private var apiCaller: APICallerProtocol
    
    init(with service: APICallerProtocol) {
        self.apiCaller = service
    }
    
    func loadCritics() {
        
    }
}
