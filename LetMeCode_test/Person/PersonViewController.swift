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
    private var articles = [ReviewesTableViewCellViewModel]()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .green
        scrollView.frame = view.bounds
        scrollView.contentSize = contenSize
        return scrollView
    }()
    private var contenSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 400)
    }
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        view.frame.size = contenSize
        return view
    }()
    
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

    private func setupScrollView() {
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    private func setupViews() {
        // setup personView
        personView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        personView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        personView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true

        // setup tableView
        tableView.topAnchor.constraint(equalTo: personView.bottomAnchor, constant: 10).isActive = true
        tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        contentView.addSubview(personView)
        contentView.addSubview(tableView)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
//        view.addSubview(personView)
//        view.addSubview(tableView)
        
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
        setupScrollView()
        setupViews()
        // setup personView
//        personView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
//        personView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
//        personView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true

        // setup tableView
//        tableView.topAnchor.constraint(equalTo: personView.bottomAnchor, constant: 10).isActive = true
//        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
            
            self.title = self.person?.title ?? "Person"
            self.personView.title.text = self.person?.title
            self.personView.status.text = self.person?.status == "" ? "no status" : self.person?.status
            self.personView.bio.text = self.person?.bio
            
            var img : UIImage
            if self.person?.imageData == nil {
                img = UIImage(named: "no photo.png")!
            } else {
                img = UIImage(data: (self.person?.imageData)!)!
            }
            self.personView.imageView.image = img
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

