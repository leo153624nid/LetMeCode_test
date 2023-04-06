//
//  CriticsViewController.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import UIKit

protocol CriticsViewProtocol: AnyObject {
    func showCritics(critics: String) // todo
}

class CriticsViewController: UIViewController {
    var presenter: CriticsPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Critics"
        presenter?.viewDidLoaded()
        
    }
    
    func reviewseButtonTapped(_ sender: Any) {
        presenter?.reviewesButtonTapped()
    }
    

}

extension CriticsViewController: CriticsViewProtocol {
    func showCritics(critics: String) {
        DispatchQueue.main.async {
            // show data
        }
    }
    
    
}
