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
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(ReviewesTableViewCell.self, forCellReuseIdentifier: ReviewesTableViewCell.identifier)
        return table
    }()
    
    private var viewModels = [ReviewesTableViewCellViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reviewes"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        presenter?.viewDidLoaded()
   
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
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

extension ReviewesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let article = articles[indexPath.row]
        
//        guard let url = URL(string: article.url ?? "") else { return }
//        let vc = SFSafariViewController(url: url)
//        present(vc, animated: true, completion: nil)
    }
}

extension ReviewesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewesTableViewCell.identifier,
                                                       for: indexPath)
                as? ReviewesTableViewCell else { fatalError() }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}
