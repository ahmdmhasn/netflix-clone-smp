//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-09-08.
//

import UIKit

class HomeViewController: UIViewController {

    enum Defaults {
        static let moviesPerPage = 4
    }
    fileprivate let sectionHeaderElementKind = "SectionHeader"
    var collectionView: UICollectionView! = nil
    // MARK: Properties

    private let remote = DiscoverMoviesRemote()
    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Movie>! = nil
    private var currentPage = 1
    private var hasMoreMovies = true
    private var isFetching = false

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        Section.allCases.forEach { section in
            fetchNewPages(for: section)
        }
        configureDataSource()
    }
}
extension HomeViewController {
    enum Section: String, CaseIterable {
        case featured = "Featured"
        case discover = "Discover"
        case trending = "Trending"
        case top = "Top of All Time"
    }
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.register(
            PosterCollectionViewCell.self,
            forCellWithReuseIdentifier: PosterCollectionViewCell.reuseIdentifier
        )
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
    }
    private func createSectionHeaderRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        return UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(
            elementKind: sectionHeaderElementKind
        ) { [weak self] supplementaryView, elementKind, indexPath in
            guard let self = self else { return }
            let sectionID = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            supplementaryView.configurationUpdateHandler = { supplementaryView, state in
                guard let supplementaryCell = supplementaryView as? UICollectionViewListCell else { return }
                if sectionID == .featured { return }
                var contentConfiguration = UIListContentConfiguration.plainHeader().updated(for: state)
                contentConfiguration.text = sectionID.rawValue
                contentConfiguration.textProperties.color = UIColor.black
                contentConfiguration.textProperties.font = UIFont.boldSystemFont(ofSize: 19)
                supplementaryCell.contentConfiguration = contentConfiguration
                supplementaryCell.backgroundConfiguration = .clear()
            }
        }
    }
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
        <Section, Movie>(collectionView: collectionView){
            (collectionView: UICollectionView, indexPath: IndexPath, movie: Movie) -> UICollectionViewCell? in
            let section = Section.allCases[indexPath.section]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "\(PosterCollectionViewCell.reuseIdentifier)",
                for: indexPath) as?  PosterCollectionViewCell else { fatalError("Cannot Create cell") }
            let imageUrl = "https://image.tmdb.org/t/p/w500/\(movie.posterPath ?? "")"
            cell.configureImage(imageUrl: imageUrl)
            cell.applyEffects(for: section)
            return cell
        }
        let headerRegistration = createSectionHeaderRegistration()
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        // Initialize the data sources.
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        currentSnapshot.appendSections([.featured, .trending, .discover, .top])
        currentSnapshot.appendItems([])
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }

    func updateDataSource(with movies: [Movie], for section: Section){
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(movies, toSection: section)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func fetchNewPages(for section: Section) {
        isFetching = true
        Task {
            do {
                var movies: [Movie]
                switch section {
                case .featured:
                    movies = try await remote.featuredMovies(at: currentPage, type: .movie, time: .day)
                case .discover:
                    movies = try await remote.discoverMovies(at: currentPage)
                case .trending:
                    movies = try await remote.trendingMovies(at: currentPage, type: .tv, time: .day)
                case .top:
                    movies = try await remote.topMovies(at: currentPage)
                }
                self.currentPage += 1
                self.hasMoreMovies = movies.count > 0
                updateDataSource(with: movies, for: section)
            } catch {
                print("❌ Error: \(error)")
            }
            isFetching = false
        }
    }
}

// MARK: Layout
//
extension HomeViewController {
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = {(sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment)-> NSCollectionLayoutSection? in
            let sectionID = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            var item: NSCollectionLayoutItem
            var group: NSCollectionLayoutGroup
            var section: NSCollectionLayoutSection
            var header: NSCollectionLayoutBoundarySupplementaryItem
            switch sectionID {
            case .featured:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.7),
                    heightDimension: .fractionalWidth(0.7*1.5)
                )
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
            case .trending, .discover, .top:
                // Create Item
                item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)))
                // Create Group
                group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(200 / 1.5),
                        heightDimension: .absolute(200)),
                    subitems: [item])
                // Create Section
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                // Create Header
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(24)
                )
                header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: "SectionHeader",
                    alignment: .top)
                section.boundarySupplementaryItems = [header]
            }
            return section
        }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        return layout
    }
}
extension HomeViewController: UICollectionViewDelegate {
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
