//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-09-08.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource {
    
    enum Defaults {
        static let moviesPerPage = 20
    }
    
    // MARK: Outlets
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    // MARK: Properties
    
    private let remote = DiscoverMoviesRemote()
    private var list: [Movie] = []
    private var currentPage = 1
    private var hasMoreMovies = true
    private var isFetching = false
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchNewPages()
        
        view.addSubview(collectionView)
        
        let nibName = "\(SearchCollectionViewCell.self)"
        collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
        let headerNibName = "\(HeaderCollectionReusableView.self)"
        collectionView.register(UINib(nibName: headerNibName, bundle: nil), forSupplementaryViewOfKind: "header", withReuseIdentifier: headerNibName)
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: Networking
//
extension HomeViewController {

    func fetchNewPages() {
        guard !isFetching else { return }
        isFetching = true
        Task {
            isFetching = false
            do {
                let movies = try await remote.discoverMovies(at: currentPage)
                self.list.append(contentsOf: movies)
                self.currentPage += 1
                self.hasMoreMovies = movies.count == Defaults.moviesPerPage
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }
}

// MARK: Layout
//
extension HomeViewController {
    static func createLayout() -> UICollectionViewCompositionalLayout {
        // Create Item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1))
        )
        
        // Create Group
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(150)), subitems: [item])
        
        //Create Section
        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .paging
        
        // Create Supplementary Item
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [headerItem]
        
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension HomeViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SearchCollectionViewCell.self)", for: indexPath) as! SearchCollectionViewCell
        let item = list[indexPath.row]
        let imageUrl = "https://image.tmdb.org/t/p/w500/\(item.posterPath ?? "")"
        cell.configure(imageUrl: imageUrl, title: item.title ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(HeaderCollectionReusableView.self)", for: indexPath) as! HeaderCollectionReusableView
            return headerView
        }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (list.count - 1) && hasMoreMovies {
            fetchNewPages()
        }
    }
}
