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
    private let searchField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = " search"
        textField.borderStyle = .roundedRect
        textField.contentVerticalAlignment = .center
        textField.textAlignment = .center
        return textField
    }()
    
    private var articles = [ReviewesTableViewCellViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reviewes"
        view.backgroundColor = .lightGray
        view.addSubview(searchField)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = self.refreshControl
        searchField.delegate = self
        
        presenter?.viewDidLoaded()
        tableView.refreshControl?.beginRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchField.frame = CGRect(x: 10, y: 80, width: view.bounds.width - 20, height: 40)
        tableView.frame = CGRect(x: 10, y: 200, width: view.bounds.width - 20, height: view.bounds.height - 200)
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        // refresh data == load data
        // Костыль, чтобы не писать однотипную цепочку функций c единственным отличием:
        // В ApiCaller происходит изменение следующего урла для пагинации (меняется offset),
        // т.к. пагинация на сервере через offset
        // Исправить, если будет время
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
        
        if position > barrier && position > 0 {
            guard !(presenter?.isPaginating ?? true) else { return }
            print("fetch more")
            tableView.tableFooterView = createSpinnerFooter()
            presenter?.loadMore()  
        }
    }
}

extension ReviewesViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else { return }
        print (text.lowercased())
        presenter?.search(with: text.lowercased())
        DispatchQueue.main.async {
            self.tableView.contentOffset = .zero
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
