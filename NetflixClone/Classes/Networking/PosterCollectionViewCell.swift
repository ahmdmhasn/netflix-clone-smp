//
//  PosterCollectionViewCell.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-09-19.
//

import UIKit
class PosterCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "Poster-Cell-Reuse-Identifier"
//    let button = UIButton()
    let image = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    required init?(coder: NSCoder) {
        fatalError("Coder not implemented.")
    }
}

extension PosterCollectionViewCell {
    func configureCell() {
        image.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(image)
        let inset: CGFloat = 5
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset)
        ])
    }
    func applyEffects(for section: HomeViewController.Section) {
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.1
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(
            roundedRect: self.bounds,
            cornerRadius: self.contentView.layer.cornerRadius
        ).cgPath
    }
    func configureImage(imageUrl: String) {
        image.setImage(with: imageUrl)
    }
}
