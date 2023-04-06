//
//  ReviewesViewController.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import UIKit

protocol ReviewesViewProtocol: AnyObject {
    
}

class ReviewesViewController: UIViewController {
    var presenter: ReviewesPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ok"
        presenter?.viewDidLoaded()
   
    }
    

    

}

extension ReviewesViewController: ReviewesViewProtocol {
    
}
