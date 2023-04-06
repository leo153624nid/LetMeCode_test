//
//  ViewController.swift
//  LetMeCode_test
//
//  Created by macbook on 04.04.2023.
//

import UIKit

class ViewController: UIViewController {
    private var apiCaller: APICallerProtocol
    private let tableView: UITableView = {
        let table = UITableView()
//        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reviews"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        getAndSetNews()
    }
    
    init(with serviceManager: APICallerProtocol) {
        self.apiCaller = serviceManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.apiCaller = APICaller.shared
        super.init(coder: coder)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func getAndSetNews(pagination: Bool = false) {
        apiCaller.getReviewes(pagination: pagination) { [weak self] result in
            switch result {
                case .success(let articles):
                    self?.articles.append(contentsOf: articles)
                    print("articles: \(String(describing: self?.articles.count))")
                    self?.viewModels.append(contentsOf: articles.compactMap({
                        NewsTableViewCellViewModel(title: $0.title,
                                                   subtitle: $0.description ?? "-",
                                                   imageURL: URL(string: $0.urlToImage ?? ""))
                    }))
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error): print(error.localizedDescription)
            }
        }
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

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else { return }
//        let vc = SFSafariViewController(url: url)
//        present(vc, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier,
//                                                       for: indexPath)
//                as? NewsTableViewCell else { fatalError() }
//        cell.configure(with: viewModels[indexPath.row])
//        return cell
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) { // TODO
        let position = scrollView.contentOffset.y
        
        let barrier = tableView.contentSize.height - 100 - scrollView.frame.size.height
//        let barrier: CGFloat = -110
        
        print("position: \(position), barrier: \(barrier)")
        
        if position > barrier {
            
            print("contentSize: \(tableView.contentSize.height), scrollViewSize: \(scrollView.frame.size.height)")
            
            guard !apiCaller.isPaginating else { return }
            print("fetch more")
            tableView.tableFooterView = createSpinnerFooter()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.getAndSetNews(pagination: true)
                DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                }
            }
            
        }
    }
}


