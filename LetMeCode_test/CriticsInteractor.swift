//
//  CriticsInteractor.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import Foundation

protocol CriticsInteractorProtocol: AnyObject {
    func loadCritics(pagination: Bool)
    func refreshCritics()
    func searchCritics(with query: String)
}

class CriticsInteractor: CriticsInteractorProtocol {
    weak var presenter: CriticsPresenterProtocol?
    private var apiCaller: APICallerProtocol
    
    private var critics = [Critic]() 
    private var query = ""
    
    init(with service: APICallerProtocol) {
        self.apiCaller = service
    }
    
    func loadCritics(pagination: Bool) {
        
    }
    
    func refreshCritics() {
        
    }
    
    func searchCritics(with query: String) {
        
    }
}
