//
//  SearchViewController.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 19.03.22.
//

import UIKit
import Logging

class SearchViewController: UIViewController {
    
    enum Section {
        case categories
    }
    
    // MARK: - Properties
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, SearchCategory>!
    
    var searchController: UISearchController!
    var resultController: SearchResultsCollectionViewController!
    
    var logger = Logger(for: "SearchViewController")
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
#if DEBUG
        self.logger.logLevel = .trace
#endif
        
        self.setupView()
        self.configureDataSource()
        self.applyCategorySnapshot()
        self.setupSearchBar()
    }
    
    // MARK: - View Setup
    
    func setupView() {
        self.title = "SEARCH_TITLE".localized()
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.backgroundColor = .systemBackground
        self.collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        self.view.addSubview(self.collectionView)
        self.logger.trace("View Setup complete.")
    }
    
    #warning("Implement height calc")
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var columns = 2
        
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        while self.view.bounds.size.width / CGFloat(columns) > CGFloat(270) {
            columns += 1
        }
        
        let frame = self.view.bounds.inset(by: self.collectionView.contentInset)
        
        let itemSize = (frame.width - CGFloat(20)*CGFloat(columns-1)) / CGFloat(columns)
        
        layout.itemSize = CGSize(width: itemSize, height: itemSize-40)
        layout.minimumLineSpacing = CGFloat(20)
        layout.minimumInteritemSpacing = 0
    }
}

// MARK: - DataSource
extension SearchViewController {

    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CategoryCollectionViewCell, SearchCategory> { (cell, indexPath, itemIdentifier) in
            
            // DO STUFF
        }

        self.dataSource = UICollectionViewDiffableDataSource<Section, SearchCategory>(collectionView: self.collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: SearchCategory) -> UICollectionViewCell? in

            return self.collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }

        self.logger.trace("Configured UICollectionViewDiffableDataSource")
    }
    
    func applyCategorySnapshot() {
        let categories = [SearchCategory(),SearchCategory(),SearchCategory(),SearchCategory(),SearchCategory(),SearchCategory(),SearchCategory(),SearchCategory(),SearchCategory(),SearchCategory(),SearchCategory(),SearchCategory(),SearchCategory(),SearchCategory(),SearchCategory(),SearchCategory(),SearchCategory(),SearchCategory(),SearchCategory(),SearchCategory(),]
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, SearchCategory>()
        snapshot.appendSections([.categories])
        snapshot.appendItems(categories)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - SearchBar
extension SearchViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    func setupSearchBar() {
        self.resultController = SearchResultsCollectionViewController()
        
        self.searchController = UISearchController(searchResultsController: self.resultController)
        self.searchController.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.autocapitalizationType = .none
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.spellCheckingType = .no
        self.searchController.automaticallyShowsSearchResultsController = true
        self.searchController.showsSearchResultsController = true
        
        // TODO: Add possibility to search for specific category of content
        // self.searchController.searchBar.scopeButtonTitles = ["GENERAL_ALL".localized() ,"GENERAL_RECORD".localized(), "GENERAL_PLAYLIST".localized()]
        
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.definesPresentationContext = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.resultController.searchFor(term: searchController.searchBar.text.orEmpty())
    }
}
