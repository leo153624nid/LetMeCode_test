//
//  ReviewesViewController.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import UIKit

protocol ReviewesViewProtocol: AnyObject {
    func showReviewes(reviewes: String) // todo
}

class ReviewesViewController: UIViewController {
    var presenter: ReviewesPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reviewes"
        presenter?.viewDidLoaded()
   
    }
    
    func criticsButtonTapped(_ sender: Any) {
        presenter?.criticsButtonTapped()
    }

}

extension ReviewesViewController: ReviewesViewProtocol {
    func showReviewes(reviewes: String) {
        DispatchQueue.main.async {
            // show data
        }
    }
    
    
}
