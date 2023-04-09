//
//  CriticsCollectionViewCell.swift
//  LetMeCode_test
//
//  Created by macbook on 09.04.2023.
//

import UIKit

class CriticsCollectionViewCell: UICollectionViewCell {
    static let identifier = "CriticsCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(
            x: 5,
            y: 5,
            width: contentView.frame.size.width - 10,
            height: contentView.frame.size.height - 30)
        titleLabel.frame = CGRect(
            x: 10,
            y: contentView.frame.size.height - 30,
            width: contentView.frame.size.width - 10,
            height: 30)
        contentView.backgroundColor = .white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        imageView.image = nil
    }
    
    func configure(with viewModel: CriticsCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        
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
