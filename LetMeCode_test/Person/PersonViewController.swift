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
        let table = UITableView()
        table.register(ReviewesTableViewCell.self, forCellReuseIdentifier: ReviewesTableViewCell.identifier)
        return table
    }()
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    private let personView: UIView = {
        let bar = UIView(frame: CGRect(x: 5, y: 0, width: UIScreen.main.bounds.width - 10, height: 200)) // todo
        bar.backgroundColor = .green
        
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 6
            imageView.layer.masksToBounds = true
            imageView.clipsToBounds = true
            imageView.backgroundColor = .secondarySystemBackground
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        let title: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.font = .systemFont(ofSize: 18, weight: .semibold)
            return label
        }()
        let status: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.font = .systemFont(ofSize: 13, weight: .semibold)
            return label
        }()
        let bio: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.font = .systemFont(ofSize: 13, weight: .light)
            label.textAlignment = .left
            return label
        }()
        
        bar.addSubview(imageView)
        bar.addSubview(title)
        bar.addSubview(status)
        bar.addSubview(bio)

        return bar
    }()

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
//        searchField.frame = CGRect(x: 10, y: 60, width: view.bounds.width - 20, height: 40)
//        dateField.frame = CGRect(x: 10, y: 120, width: view.bounds.width - 20, height: 40)
        tableView.frame = CGRect(x: 10, y: 180, width: view.bounds.width - 20, height: view.bounds.height - 180)
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

