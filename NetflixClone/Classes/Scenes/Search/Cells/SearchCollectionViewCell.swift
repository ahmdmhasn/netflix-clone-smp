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
    }
    required init?(coder: NSCoder) {
        fatalError("Coder not implemented.")
    }
}

extension SearchCollectionViewCell {
    func configureCell(cellHeight: CGFloat, title text: String) {

        stackView = UIStackView(frame: contentView.bounds)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: cellHeight/1.5, height: cellHeight))
        image.translatesAutoresizingMaskIntoConstraints = false
        label = UILabel()
        label.text = text
        button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 24, height: 24))
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        
        let inset: CGFloat = 5
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: cellHeight),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.heightAnchor.constraint(equalToConstant: cellHeight),
            image.widthAnchor.constraint(equalToConstant: cellHeight/1.5),
        ])
    }
    func configureImage(imageUrl: String) {
        image.setImage(with: imageUrl)
    }
}
