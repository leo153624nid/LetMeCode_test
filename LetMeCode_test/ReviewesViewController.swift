//
//  ReviewesViewController.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import UIKit
import SafariServices

protocol ReviewesViewProtocol: AnyObject {
    func showReviewes(articles: [ReviewesTableViewCellViewModel])
}

class ReviewesViewController: UIViewController {
    var presenter: ReviewesPresenterProtocol?
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(ReviewesTableViewCell.self, forCellReuseIdentifier: ReviewesTableViewCell.identifier)
        return table
    }()
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private var articles = [ReviewesTableViewCellViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reviewes"
        view.backgroundColor = .lightGray
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = self.refreshControl
        
        presenter?.viewDidLoaded()
        tableView.refreshControl?.beginRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
        tableView.frame = CGRect(x: 10, y: 200, width: view.bounds.width - 20, height: view.bounds.height - 200)
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        // refresh data == load data
        presenter?.viewDidLoaded()
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.frame.size.width,
                                              height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    func criticsButtonTapped(_ sender: Any) {
        presenter?.criticsButtonTapped()
    }

}

extension ReviewesViewController: ReviewesViewProtocol {
    func showReviewes(articles: [ReviewesTableViewCellViewModel]) {
        self.articles = articles
        print("reviewes: \(String(describing: self.articles.count))")
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.tableFooterView = nil
            self.tableView.reloadData()
        }
    }
}

extension ReviewesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = article.linkURL else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
}

extension ReviewesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewesTableViewCell.identifier,
                                                       for: indexPath)
                as? ReviewesTableViewCell else { fatalError() }
        
        cell.configure(with: articles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension ReviewesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let barrier = tableView.contentSize.height - 100 - scrollView.frame.size.height
        
        if position > barrier {
            guard !(presenter?.isPaginating ?? false) else { return }
            print("fetch more")
            tableView.tableFooterView = createSpinnerFooter()
            presenter?.loadMore()  
        }
    }
}
