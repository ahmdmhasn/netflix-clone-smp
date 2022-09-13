//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-09-08.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        
        let nibName = "\(SearchCollectionViewCell.self)"
        collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
        let headerNibName = "\(HeaderCollectionReusableView.self)"
        collectionView.register(UINib(nibName: headerNibName, bundle: nil), forSupplementaryViewOfKind: "header", withReuseIdentifier: headerNibName)
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        // Create Item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        )
        
        // Create Group
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(2/5)),
            repeatingSubitem: item, count: 2
        )
        
        //Create Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        // Create Supplementary Item
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [headerItem]
        
        
        return UICollectionViewCompositionalLayout(section: section)
    }

}

extension HomeViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SearchCollectionViewCell.self)", for: indexPath) as! SearchCollectionViewCell
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(HeaderCollectionReusableView.self)", for: indexPath) as! HeaderCollectionReusableView
            return headerView
        }
    
}
