////
////  SearchCollectionViewCell.swift
////  NetflixClone
////
////  Created by Joseph Ching on 2022-09-11.
////
//
//import UIKit
//import Kingfisher
//
//class SearchCollectionViewCell: UICollectionViewCell {
//
//    @IBOutlet private weak var movieImageView: UIImageView!
//    @IBOutlet private weak var titleLabel: UILabel!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    func configure(imageUrl: String, title: String) {
//        titleLabel.text = title
//        movieImageView.kf.indicatorType = .activity
//        movieImageView.kf.setImage(
//            with: URL(string: imageUrl),
//            options: [
//                .transition(.fade(1)),
//            ])
//    }
//}
