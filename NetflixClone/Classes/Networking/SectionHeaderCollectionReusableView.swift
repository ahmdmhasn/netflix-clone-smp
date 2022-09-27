//
//  SectionHeaderCollectionReusableView.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-09-22.
//

import UIKit

class SectionHeaderCollectionReusableView: UICollectionReusableView {
    let label = UILabel()
    static let reuseIdentifier = "Section-Header-Collection-Reusable-Identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension SectionHeaderCollectionReusableView {
    func configureCell() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
        label.font = UIFont.preferredFont(forTextStyle: .title3)
    }
}
