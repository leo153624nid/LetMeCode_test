//
//  ReviewesTableViewCell.swift
//  LetMeCode_test
//
//  Created by macbook on 06.04.2023.
//

import UIKit

class ReviewesTableViewCell: UITableViewCell {
    
    static let identifier = "ReviewesTableViewCell"
    
    // MARK: - UIElements
    private let reviewesTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    private let reviewesSubTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textAlignment = .left
        return label
    }()
    private let reviewesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let reviewesBylineLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    private let reviewesDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .light)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(reviewesTitleLabel)
        contentView.addSubview(reviewesSubTitleLabel)
        contentView.addSubview(reviewesImageView)
        contentView.addSubview(reviewesBylineLabel)
        contentView.addSubview(reviewesDateLabel)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reviewesTitleLabel.frame = CGRect(
            x: 10,
            y: 10,
            width: contentView.frame.size.width - 170,
            height: 30)
        reviewesSubTitleLabel.frame = CGRect(
            x: 10,
            y: 30,
            width: contentView.frame.size.width - 170,
            height: contentView.frame.size.height - 80)
        reviewesBylineLabel.frame = CGRect(
            x: 10,
            y: contentView.frame.size.height - 60,
            width: contentView.frame.size.width - 170,
            height: 30)
        reviewesDateLabel.frame = CGRect(
            x: 10,
            y: contentView.frame.size.height - 30,
            width: contentView.frame.size.width - 170,
            height: 20)
        reviewesImageView.frame = CGRect(
            x: contentView.frame.size.width - 150,
            y: 5,
            width: 140,
            height: contentView.frame.size.height - 10)
        contentView.backgroundColor = .white
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        reviewesTitleLabel.text = nil
        reviewesSubTitleLabel.text = nil
        reviewesBylineLabel.text = nil
        reviewesImageView.image = nil
        reviewesDateLabel.text = nil
    }
    
    // MARK: - configure cell
    func configure(with viewModel: ReviewesTableViewCellViewModel) {
        reviewesTitleLabel.text = viewModel.title
        reviewesSubTitleLabel.text = viewModel.subtitle
        reviewesBylineLabel.text = viewModel.byline
        
        let date = dateFromApiString(viewModel.publicationDate ?? "")
        reviewesDateLabel.text = date?.toMyFormat
        
        // image from cache
        if let data = viewModel.imageData {
            reviewesImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            // fetching image
            DispatchQueue.global(qos: .utility).async { [weak self] in
                if let data = try? Data(contentsOf: url) {
//                    viewModel.imageData = data
                    DispatchQueue.main.async {
                        self?.reviewesImageView.image = UIImage(data: data)
                    }
                }
                else {
                    print("error fetching image")
                }
            }
        }
    }
}
