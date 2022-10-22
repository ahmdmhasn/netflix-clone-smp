//
//  UIImageView+ImageLoading.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-09-23.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with url: URL) {
        kf.indicatorType = .activity
        kf.setImage(
            with: url,
            options: [
                .transition(.fade(1))
            ])
    }
    func setImage(with urlString: String ) {
        guard let url = URL(string: urlString) else { return }
        setImage(with: url)
    }
}