//
//  SearchCollectionViewCell.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-09-11.
//

import UIKit
import Kingfisher

class SearchCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "Search-Result-Cell-Reuse-Identifier"
    var stackView: UIStackView! = nil
    var button: UIButton! = nil
    var label: UILabel! = nil
    var image: UIImageView! = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView = UIStackView(frame: contentView.bounds)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        label = UILabel()

        button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        let inset: CGFloat = 5
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            image.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/1.5)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("Coder not implemented.")
    }
}

extension SearchCollectionViewCell {
    func configureCell(title text: String) {
        label.text = text
    }
    func configureImage(imageUrl: String) {
        image.setImage(with: imageUrl)
    }
}
