//
//  PersonViewController.swift
//  LetMeCode_test
//
//  Created by macbook on 09.04.2023.
//

import UIKit
import SafariServices

protocol PersonViewProtocol: AnyObject {
    var person: CriticsCollectionViewCellViewModel? { get set }
    func showReviewes(articles: [ReviewesTableViewCellViewModel])
}

class PersonViewController: UIViewController {
    var presenter: PersonPresenterProtocol?
    var person: CriticsCollectionViewCellViewModel?
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ReviewesTableViewCell.self, forCellReuseIdentifier: ReviewesTableViewCell.identifier)
        return table
    }()
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    private let personView = PersonDetailView()

    private var articles = [ReviewesTableViewCellViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        view.addSubview(personView)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = self.refreshControl
        
        presenter?.viewDidLoaded()
        tableView.refreshControl?.beginRefreshing()
    }
    override func viewDidAppear(_ animated: Bool) {
        title = person?.title ?? "Person"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // setup personView
        personView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        personView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        personView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
//        personView.heightAnchor.constraint(equalToConstant: 104).isActive = true
        
        // setup tableView
        tableView.topAnchor.constraint(equalTo: personView.bottomAnchor, constant: 10).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        tableView.frame = CGRect(x: 10, y: 180, width: view.bounds.width - 20, height: view.bounds.height - 180)
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        presenter?.refresh()
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
            self.title = self.person?.title ?? "222"
            // show person data
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

