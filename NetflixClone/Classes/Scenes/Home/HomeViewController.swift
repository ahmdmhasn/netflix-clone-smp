//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-09-08.
//

import UIKit
import SwiftUI
import Combine

class HomeViewController: UIViewController {
    // MARK: Properties
    typealias Section = HomeViewModel.Section
    
    private var viewModel: HomeViewModel
    private var subscribers: [AnyCancellable] = []

    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Movie>! = nil
    fileprivate let sectionHeaderElementKind = "SectionHeader"
    var collectionView: UICollectionView! = nil
    private var currentPage = 1
    

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        initializeSections()
        configureDataSource()
        // MARK: Receivers
        viewModel.$result
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                self.updateDataSource(movies: result.newMovies)
            }
            .store(in: &subscribers)
    }
}

extension HomeViewController {
    private func initializeSections() {
        Section.allCases.forEach { section in
            viewModel.fetchNewPages(for: section, at: currentPage)
        }
    }
}

extension HomeViewController {

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
        ) { [weak self] supplementaryView, _, indexPath in
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
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
        <Section, Movie>(collectionView: collectionView) {
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
        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }

        // Initialize the data sources.
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        currentSnapshot.appendSections([.featured, .trending, .discover, .top])
        currentSnapshot.appendItems([])
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
    private func updateDataSource(movies: [Movie]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(movies)
        if movies.count > 0 { currentPage+=1 }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Layout
extension HomeViewController {
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = {(sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
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
        if indexPath.row == (snapshot.numberOfItems(inSection: section)-1) {
            let section = snapshot.sectionIdentifiers[indexPath.section]
            viewModel.fetchNewPages(for: section, at: currentPage)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        let section = snapshot.sectionIdentifiers[indexPath.section]
        let items = snapshot.itemIdentifiers(inSection: section)
        let movie = items[indexPath.row]

//        let viewController = MovieDetailsViewController(movie: movie)
//        present(viewController, animated: true)
        
        let infoViewModel = MovieInfoViewModel(id: movie.id,title: movie.title, posterPath: movie.posterPath, description: movie.overview, rating: movie.voteAverage, date: movie.releaseDate)
        let infoView = MovieInfoView(viewModel: infoViewModel)
        
        let infoViewUIWrapper = UIHostingController(rootView: infoView)
        present(infoViewUIWrapper, animated: true)
    }
}
