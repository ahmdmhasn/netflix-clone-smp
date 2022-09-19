//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-09-11.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        
        let nibName = "\(SearchCollectionViewCell.self)"
        searchCollectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }

}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SearchCollectionViewCell.self)", for: indexPath) as! SearchCollectionViewCell
        return collectionViewCell
    }
    
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize
    {
        let width = collectionView.bounds.width/3
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
}
