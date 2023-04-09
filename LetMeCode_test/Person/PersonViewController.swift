//
//  PersonViewController.swift
//  LetMeCode_test
//
//  Created by macbook on 09.04.2023.
//

import UIKit
import SafariServices

protocol PersonViewProtocol: AnyObject {
    func showReviewes(articles: [ReviewesTableViewCellViewModel])
}

class PersonViewController: UIViewController {
    var presenter: PersonPresenterProtocol?
    
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
        title = "Person" // todo
        view.backgroundColor = .lightGray
//        view.addSubview(bar)
//        view.addSubview(searchField)
//        view.addSubview(dateField)
        view.addSubview(tableView)
        setupNavigationBar()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = self.refreshControl
        
        presenter?.viewDidLoaded()
        tableView.refreshControl?.beginRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        searchField.frame = CGRect(x: 10, y: 60, width: view.bounds.width - 20, height: 40)
//        dateField.frame = CGRect(x: 10, y: 120, width: view.bounds.width - 20, height: 40)
        tableView.frame = CGRect(x: 10, y: 180, width: view.bounds.width - 20, height: view.bounds.height - 180)
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        presenter?.refresh()
    }
    
    private func setupNavigationBar() {
        let navBar = self.navigationController?.navigationBar
        navBar?.isTranslucent = false
        navBar?.barTintColor = .orange
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar?.tintColor = .white
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reviewes", style: .plain, target: self, action: #selector(reviewesButtonTapped))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Critics", style: .plain, target: self, action: #selector(criticsButtonTapped))
    }
    
    @objc private func reviewesButtonTapped(_ sender: Any) { // todo
        
    }
    
    @objc private func criticsButtonTapped(_ sender: Any) {
        presenter?.criticsButtonTapped()
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
}

extension PersonViewController: PersonViewProtocol {
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

extension PersonViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = article.linkURL else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
}

extension PersonViewController: UITableViewDataSource {
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

extension PersonViewController: UIScrollViewDelegate {
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

