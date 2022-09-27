//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-09-11.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: Properties
    private enum Defaults {
        static let itemsPerPage = 10
    }
    var collectionView: UICollectionView! = nil
    private let remote = DiscoverMoviesRemote()
//    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>! = nil
//    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Movie>! = nil
    private var currentPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()
         
    }

}
