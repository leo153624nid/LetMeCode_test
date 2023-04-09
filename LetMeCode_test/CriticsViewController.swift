//
//  CriticsViewController.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import UIKit

protocol CriticsViewProtocol: AnyObject {
    func showCritics(articles: [ReviewesTableViewCellViewModel]) // todo
}

class CriticsViewController: UIViewController {
    var presenter: CriticsPresenterProtocol?
    
    private let searchField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "search"
        textField.borderStyle = .roundedRect
        textField.contentVerticalAlignment = .center
        textField.textAlignment = .center
        textField.tintColor = .lightGray
        
        // add icon
        let imgView = UIImageView(frame: CGRect(x: 8, y: 0, width: 20, height: 20))
        let img = UIImage(systemName: "magnifyingglass")
        imgView.image = img
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = .lightGray
        imgView.backgroundColor = .clear
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.addSubview(imgView)
        view.backgroundColor = .clear
        textField.leftViewMode = .always
        textField.leftView = view
        textField.rightViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        return textField
    }()
    private let bar: UIView = {
        let bar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        bar.backgroundColor = .orange
        
        let buttonReviewes: UIButton = {
            let button = UIButton(frame: CGRect(x: 10,
                                                y: 0,
                                                width: bar.frame.size.width / 2 - 10,
                                                height: 30))
            button.addTarget(self, action: #selector(reviewesButtonTapped), for: .touchUpInside)
            button.setTitle("Reviewes", for: .normal)
            button.setTitleColor(.orange, for: .normal)
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
            
            return button
        }()
        let buttonCritics: UIButton = {
            let button = UIButton(frame: CGRect(x: bar.frame.size.width / 2,
                                                y: 0,
                                                width: bar.frame.size.width / 2 - 10,
                                                height: 30))
            button.addTarget(self, action: #selector(criticsButtonTapped), for: .touchUpInside)
            button.setTitle("Critics", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .orange
            button.layer.borderWidth = 1
            button.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)

            return button
        }()
        
        bar.addSubview(buttonReviewes)
        bar.addSubview(buttonCritics)

        return bar
    }()
    
    private var articles = [ReviewesTableViewCellViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Critics"
        view.backgroundColor = .lightGray
        view.addSubview(bar)
        view.addSubview(searchField)
//        view.addSubview(tableView)
        setupNavigationBar()
        
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.refreshControl = self.refreshControl
        searchField.delegate = self
        
        presenter?.viewDidLoaded()
//        tableView.refreshControl?.beginRefreshing() 
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchField.frame = CGRect(x: 10, y: 60, width: view.bounds.width - 20, height: 40)
//        tableView.frame = CGRect(x: 10, y: 180, width: view.bounds.width - 20, height: view.bounds.height - 180)
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        presenter?.refresh()
        searchField.text = nil
    }
    
    private func setupNavigationBar() {
        let navBar = self.navigationController?.navigationBar
        navBar?.isTranslucent = false
        navBar?.barTintColor = .orange
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar?.tintColor = .white
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
    }
    
    @objc private func reviewesButtonTapped(_ sender: Any) {
        presenter?.reviewesButtonTapped()
    }
    
    @objc private func criticsButtonTapped(_ sender: Any) {
        
    }
    
//    private func createSpinnerFooter() -> UIView {
//        let footerView = UIView(frame: CGRect(x: 0,
//                                              y: 0,
//                                              width: view.frame.size.width,
//                                              height: 100))
//        let spinner = UIActivityIndicatorView()
//        spinner.center = footerView.center
//        footerView.addSubview(spinner)
//        spinner.startAnimating()
//        return footerView
//    }
}

extension CriticsViewController: CriticsViewProtocol {
    func showCritics(articles: [ReviewesTableViewCellViewModel]) { // todo
        self.articles = articles
        print("critics: \(String(describing: self.articles.count))")
        DispatchQueue.main.async {
//            self.tableView.refreshControl?.endRefreshing()
//            self.tableView.tableFooterView = nil
//            self.tableView.reloadData()
        }
    }
}

extension CriticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
//        guard let url = article.linkURL else { return }
        let vc = UIViewController() // todo
        present(vc, animated: true, completion: nil)
    }
}

extension CriticsViewController: UITableViewDataSource {
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

extension CriticsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
//        let barrier = tableView.contentSize.height - 100 - scrollView.frame.size.height
        
//        if position > barrier && position > 0 {
//            guard !(presenter?.isPaginating ?? true) else { return }
//            print("fetch more")
//            tableView.tableFooterView = createSpinnerFooter()
//            presenter?.loadMore()
//        }
    }
}

extension CriticsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchField {
            guard let text = textField.text, !text.isEmpty else { return }
            print (text.lowercased())
//            tableView.refreshControl?.beginRefreshing()
            presenter?.search(with: text.lowercased())
            DispatchQueue.main.async {
//                self.tableView.contentOffset = .zero
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
