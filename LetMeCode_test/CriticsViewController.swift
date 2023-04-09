//
//  CriticsViewController.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import UIKit

protocol CriticsViewProtocol: AnyObject {
    func showCritics(articles: [CriticsCollectionViewCellViewModel])
}

class CriticsViewController: UIViewController {
    var presenter: CriticsPresenterProtocol?
    
    private var collectionView: UICollectionView!
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
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
        bar.backgroundColor = .blue
        
        let buttonReviewes: UIButton = {
            let button = UIButton(frame: CGRect(x: 10,
                                                y: 0,
                                                width: bar.frame.size.width / 2 - 10,
                                                height: 30))
            button.addTarget(self, action: #selector(reviewesButtonTapped), for: .touchUpInside)
            button.setTitle("Reviewes", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .blue
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
            button.setTitleColor(.blue, for: .normal)
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)

            return button
        }()
        
        bar.addSubview(buttonReviewes)
        bar.addSubview(buttonCritics)

        return bar
    }()
    
    private var articles = [CriticsCollectionViewCellViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Critics"
        view.backgroundColor = .lightGray
        view.addSubview(bar)
        view.addSubview(searchField)
        setupCollectionView()
        setupNavigationBar()
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = self.refreshControl
        searchField.delegate = self
        
        presenter?.viewDidLoaded()
        collectionView.refreshControl?.beginRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchField.frame = CGRect(x: 10,
                                   y: 60,
                                   width: view.bounds.width - 20,
                                   height: 40)
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        presenter?.refresh()
        searchField.text = nil
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: CGRect(x: 10,
                                                        y: 130,
                                                        width: view.bounds.width - 20,
                                                        height: view.bounds.height - 130),
                                          collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .lightGray
        collectionView.register(CriticsCollectionViewCell.self,
                                forCellWithReuseIdentifier: CriticsCollectionViewCell.identifier)
    }
    private func setupNavigationBar() {
        let navBar = self.navigationController?.navigationBar
        navBar?.isTranslucent = false
        navBar?.barTintColor = .blue
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar?.tintColor = .white
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
    }
    
    @objc private func reviewesButtonTapped(_ sender: Any) {
        presenter?.reviewesButtonTapped()
    }
    @objc private func criticsButtonTapped(_ sender: Any) {
        // заглушка (для будущего расширения)
    }
}

extension CriticsViewController: CriticsViewProtocol {
    func showCritics(articles: [CriticsCollectionViewCellViewModel]) {
        self.articles = articles
        print("critics: \(String(describing: self.articles.count))")
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
}

extension CriticsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        presenter?.personButtonTapped(with: article)
        
    }
}

extension CriticsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CriticsCollectionViewCell.identifier,
                for: indexPath)
                as? CriticsCollectionViewCell else { fatalError() }
        
        cell.configure(with: articles[indexPath.row])
        return cell
    }
}

extension CriticsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: view.frame.size.width / 2 - 20, height: 200)
    }
}

extension CriticsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let barrier = collectionView.contentSize.height - 100 - scrollView.frame.size.height
        
        if position > barrier && position > 0 {
            guard !(presenter?.isPaginating ?? true) else { return }
            print("fetch more")
            presenter?.loadMore()
        }
    }
}

extension CriticsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchField {
            guard let text = textField.text, !text.isEmpty else { return }
            print (text)
            
            collectionView.refreshControl?.beginRefreshing()
            presenter?.search(with: text)
            
            DispatchQueue.main.async {
                self.collectionView.contentOffset = .zero
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
