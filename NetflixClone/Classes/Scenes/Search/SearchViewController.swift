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
        static let imageHeight = 120
    }
    private let remote = DiscoverMoviesRemote()
    private var currentPage = 1
    private var hasMoreMovies = true
    private var query: [String] = []
    // MARK: Views
    var stackView: UIStackView! = nil
    var searchBar: UISearchBar! = nil
    var collectionView: UICollectionView! = nil
    // MARK: Data sources
    var dataSource: UICollectionViewDiffableDataSource<Section, MovieSearchMulti>! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
}
// MARK: - Configurations
extension SearchViewController {
    enum Section: String, CaseIterable {
        case mainResults = "Main Results"
    }
    private func configureHierarchy() {
        stackView = UIStackView(frame: view.bounds)
        stackView.axis = .vertical
        stackView.alignment = .fill
        searchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 48.0))
        searchBar.delegate = self
        searchBar.showsSearchResultsButton = true
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.register(
            SearchCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier
        )
        collectionView.backgroundColor = .white
        stackView.backgroundColor = .white
        view.backgroundColor = .white
        self.view.addSubview(stackView)
        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(collectionView)
        let margins = view.layoutMarginsGuide
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let inset: CGFloat = 0
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            stackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: inset),
            stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -inset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
        ])
    }
}
// MARK: - Data Source
extension SearchViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
        <Section, MovieSearchMulti>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, movie: MovieSearchMulti) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "\(SearchCollectionViewCell.reuseIdentifier)",
                for: indexPath) as? SearchCollectionViewCell else { fatalError("Cannot Create cell") }
            let imageUrl = "https://image.tmdb.org/t/p/w500/\(movie.posterPath ?? "")"
            cell.configureCell(title: movie.title ?? "Unknown" )
            cell.configureImage(imageUrl: imageUrl)
            return cell
        }
        setDataSource(movies: [])
    }
    func setDataSource(movies: [MovieSearchMulti]) {
        // Initialize the data sources.
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieSearchMulti>()
        snapshot.appendSections([.mainResults])
        snapshot.appendItems(movies)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    func updateDataSource(movies: [MovieSearchMulti]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(movies)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Networking
extension SearchViewController {
    func newQuery(for section: Section) {
        guard query.count == 0 else { return }
        Task {
            do {
                // Remove all existing movies.
                collectionView.setContentOffset(.zero, animated: false)
                var movies: [MovieSearchMulti]
                self.currentPage = 1
                setDataSource(movies: [])
                fetchNewPages(for: section)
            }
        }
    }
    func fetchNewPages(for section: Section) {
        guard query.count == 0 else { return }
        Task {
            do {
                var movies: [MovieSearchMulti]
                switch section {
                case .mainResults:
                    movies = try await remote.searchMulti(query: query, at: currentPage)
                }
                self.currentPage += 1
                self.hasMoreMovies = movies.count > 0
                updateDataSource(movies: movies)
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }

}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        let snapshot = dataSource.snapshot()
        let section = snapshot.sectionIdentifiers[indexPath.section]
        if indexPath.row == (snapshot.numberOfItems(inSection: section)-1) && hasMoreMovies {
            let section = snapshot.sectionIdentifiers[indexPath.section]
            fetchNewPages(for: section)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        query = searchText.components(separatedBy: " ")
        newQuery(for: .mainResults)
    }
}

// MARK: - Layout
extension SearchViewController {
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment)-> NSCollectionLayoutSection? in
            var item: NSCollectionLayoutItem
            var group: NSCollectionLayoutGroup
            var section: NSCollectionLayoutSection
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            item = NSCollectionLayoutItem(layoutSize:  itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(CGFloat(Defaults.imageHeight))
            )
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(100)
            section = NSCollectionLayoutSection(group: group)
            return section
        }
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        layout.configuration.interSectionSpacing = 8
        return layout
    }
}
