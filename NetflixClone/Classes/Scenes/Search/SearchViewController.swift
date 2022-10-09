//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-09-11.
//

import UIKit
import Combine
class SearchViewController: UIViewController {
    // MARK: Properties
    
    private var viewModel: SearchViewModel
    typealias Section = SearchViewModel.Section
    private var subscribers: [AnyCancellable] = []
    
    private enum Defaults {
        static let itemsPerPage = 10
        static let imageHeight = 120
    }
    
    private var currentPage = 1
    private var query: [String] = []
    // MARK: Views
    var stackView: UIStackView! = nil
    var searchBar: UISearchBar! = nil
    var collectionView: UICollectionView! = nil
    // MARK: Data sources
    var dataSource: UICollectionViewDiffableDataSource<Section, MovieSearchMulti>! = nil
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        
        viewModel.$result
            .receive(on: DispatchQueue.main)
            .sink { result in
                if let result = result {
                    self.updateDataSource(movies: result.newMovies)
                }
            }
            .store(in: &subscribers)
    }
}
// MARK: - Configurations
extension SearchViewController {
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
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset)
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
        resetUIDataSource()
    }
    func resetUIDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieSearchMulti>()
        snapshot.appendSections([Section.mainResults])
        snapshot.appendItems([])
        dataSource.apply(snapshot, animatingDifferences: true)
        currentPage = 1
    }
    func updateDataSource(movies: [MovieSearchMulti]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(movies)
        if movies.count > 0 { currentPage+=1 }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Networking
extension SearchViewController {
    func newQuery(for section: Section) {
        guard query.count > 0 else { return }
        Task {
            do {
                collectionView.setContentOffset(.zero, animated: false)
                resetUIDataSource()
                viewModel.fetchNewPages(for: section, at: currentPage, with: query)
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
        if indexPath.row == (snapshot.numberOfItems(inSection: section)-1) {
            let section = snapshot.sectionIdentifiers[indexPath.section]
            viewModel.fetchNewPages(for: section, at: currentPage, with: query)
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
            (_: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            var item: NSCollectionLayoutItem
            var group: NSCollectionLayoutGroup
            var section: NSCollectionLayoutSection
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            item = NSCollectionLayoutItem(layoutSize: itemSize)
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
