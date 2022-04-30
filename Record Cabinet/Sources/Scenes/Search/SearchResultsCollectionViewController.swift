//
//  SearchResultsCollectionViewController.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 30.04.22.
//

import UIKit
import Logging
import CoreData

class SearchResultsCollectionViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    // MARK: - Properties
    
    var logger = Logger(for: "SearchResultsCollectionViewController")
    
    var container: NSPersistentContainer!
    var fetchedResults: [Record] = []
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Record>!
    
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
#if DEBUG
        self.logger.logLevel = .trace
#endif

        self.setupView()
        self.configureDataSource()
        
        // Core Data
        self.container = NSPersistentContainer(name: "Record_Cabinet")
        
        self.container.loadPersistentStores { storeDescription, error in
            if let error = error {
                self.logger.error("Unresolved error: \(error)")
                
                let alert = UIAlertController(title: "ALERT_ERROR".localized(), message: "ALERT_ERROR_MESSAGE".localized(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: .cancel))
                
                self.present(alert, animated: true)
            }
        }
    }
    
    func setupView() {
        let layout = UICollectionViewFlowLayout()
        
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.backgroundColor = .systemBackground
        self.collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        self.view.addSubview(self.collectionView)
        self.logger.trace("View setup successful")
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
        
        layout.itemSize = CGSize(width: itemSize, height: itemSize+50)
        layout.minimumLineSpacing = CGFloat(20)
        layout.minimumInteritemSpacing = 0
    }
}

// MARK: - Data Source
extension SearchResultsCollectionViewController {
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<RecordCollectionViewCell, Record> { (cell, indexPath, itemIdentifier) in
            cell.recordLabel.text = itemIdentifier.name
            cell.artistLabel.text = itemIdentifier.artist
        }
        
        self.dataSource = UICollectionViewDiffableDataSource<Section, Record>(collectionView: self.collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Record) -> UICollectionViewCell? in
            
            return self.collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        self.logger.trace("Configured UICollectionViewDiffableDataSource")
    }
}

// MARK: - Search
extension SearchResultsCollectionViewController {
    
    func searchFor(term: String) {
        self.logger.trace("Start search for term '\(term)'")
        
        // Remove leading and trailing whitespaces and split into multiple items
        let whitespacesCharacterSet = CharacterSet.whitespacesAndNewlines
        let termTrimmed = term.trimmingCharacters(in: whitespacesCharacterSet)
        let termItems = termTrimmed.components(separatedBy: whitespacesCharacterSet) as [String]
        
        
        
        let request = Record.createFetchRequest()
        let titlePredicate = NSPredicate(format: "name LIKE %@", term.appending("*"))
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            titlePredicate
        ])
        
        let context = self.container.viewContext
        self.logger.trace("FetchRequest: \(request.debugDescription)")
        
        do {
            self.fetchedResults = try context.fetch(request)
            self.logger.trace("Fetched \(self.fetchedResults.count) results")
            
            var snapshot = NSDiffableDataSourceSnapshot<Section, Record>()
            snapshot.appendSections([.main])
            snapshot.appendItems(self.fetchedResults)
            
            self.dataSource.apply(snapshot, animatingDifferences: true)
        } catch {
            self.logger.error("There was an error: \(error.localizedDescription)")
            
            let alert = UIAlertController(title: "ALERT_ERROR".localized(), message: "ALERT_ERROR_MESSAGE".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: .cancel))
            
            self.present(alert, animated: true)
            return
        }
        
       
    }
    
}
