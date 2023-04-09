//
//  CriticsCollectionViewCell.swift
//  LetMeCode_test
//
//  Created by macbook on 09.04.2023.
//

import UIKit

class CriticsCollectionViewCell: UICollectionViewCell {
    static let identifier = "CriticsCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textAlignment = .left
        return label
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let bylineLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(bylineLabel)
        contentView.addSubview(dateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(
            x: 10,
            y: 10,
            width: contentView.frame.size.width - 170,
            height: 30)
        subTitleLabel.frame = CGRect(
            x: 10,
            y: 30,
            width: contentView.frame.size.width - 170,
            height: contentView.frame.size.height - 80)
        bylineLabel.frame = CGRect(
            x: 10,
            y: contentView.frame.size.height - 60,
            width: contentView.frame.size.width - 170,
            height: 30)
        dateLabel.frame = CGRect(
            x: 10,
            y: contentView.frame.size.height - 30,
            width: contentView.frame.size.width - 170,
            height: 20)
        imageView.frame = CGRect(
            x: contentView.frame.size.width - 150,
            y: 5,
            width: 140,
            height: contentView.frame.size.height - 10)
        contentView.backgroundColor = .white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subTitleLabel.text = nil
        bylineLabel.text = nil
        imageView.image = nil
        dateLabel.text = nil
    }
    
    func configure(with viewModel: CriticsCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.status
        bylineLabel.text = viewModel.bio
        
        // image from cache
        if let data = viewModel.imageData {
            imageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            // fetching image
            DispatchQueue.global(qos: .utility).async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    viewModel.imageData = data
                    DispatchQueue.main.async {
                        self?.imageView.image = UIImage(data: data)
                    }
                }
                else {
                    print("error fetching image")
                }
            }
        }
    }
}
