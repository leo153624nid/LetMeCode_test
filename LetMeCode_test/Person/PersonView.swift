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
        imageView.image = UIImage(named: "no photo.png") // todo
        return imageView
    }()
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "Test Title" // todo
        return label
    }()
    let status: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.backgroundColor = .blue
        label.tintColor = .white
        label.text = "Test status" // todo
        return label
    }()
    let bio: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textAlignment = .left
        label.text = "Lorem Ipsum - это текст-рыба, часто используемый в печати ивэб-дизайне. Lorem Ipsum является стандартной рыбой для текстов налатинице с начала XVI века. В то время некий безымянный печатник создал большую коллекцию размеров и форм шрифтов,используя Lorem Ipsum для распечатки образцов. Lorem Ipsum не только успешнопережил без заметных изменений пять веков, но и перешагнул в электронныйдизайн. Его популяризации в новое время послужили публикация листовLetraset с образцами Lorem Ipsum в 60-х годах и, в более недавнее время,программы электронной вёрстки типа Aldus PageMaker, в шаблонах которыхиспользуется Lorem Ipsum."
        return label
    }()

    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .green
        
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
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.33).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        // setup title
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        title.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20).isActive = true
        title.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.66).isActive = true
        title.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // setup status
        status.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        status.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20).isActive = true
        status.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.66).isActive = true
        status.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // setup bio
        bio.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        bio.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
        bio.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.95).isActive = true
//        bio.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}



