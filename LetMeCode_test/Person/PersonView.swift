//
//  PersonView.swift
//  LetMeCode_test
//
//  Created by macbook on 09.04.2023.
//

import Foundation
import UIKit

class PersonDetailView: UIView {
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
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    let status: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.backgroundColor = .blue
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    let bio: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 6 // todo
        label.font = .systemFont(ofSize: 11, weight: .light)
        label.textAlignment = .left
        return label
    }()

    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        
        self.addSubview(imageView)
        self.addSubview(title)
        self.addSubview(status)
        self.addSubview(bio)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        // setup imageView
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.44).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        // setup title
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        title.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20).isActive = true
        title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        title.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // setup status
        status.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        status.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20).isActive = true
        status.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        status.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // setup bio
        bio.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        bio.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        bio.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        bio.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }
}



