//
//  ArtistRecordsCollectionViewController.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 04.05.22.
//

import UIKit
import Logging
import CoreData

class ArtistRecordsCollectionViewController: UIViewController {

    enum Section {
        case main
    }
    
    // MARK: - Properties
    
    var artist: String
    
    var container: NSPersistentCloudKitContainer!
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Record>!
    
    var logger = Logger(for: "ArtistRecordsCollectionViewController")
    
    // MARK: - Init
    
    init(for artist: String) {
        self.artist = artist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
#if DEBUG
        self.logger.logLevel = .trace
#endif
        
        self.setupView()
        self.configureDataSource()
        
        // Core Data
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.container = appDelegate.persistentContainer
        
        self.loadData()
        
    }
    
    // MARK: - View Setup
    
    func setupView() {
        self.title = artist
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
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
extension ArtistRecordsCollectionViewController {
    
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


// MARK: - Load Data
extension ArtistRecordsCollectionViewController {
    
    func loadData() {
        let request  = Record.createFetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        
        let artistPredicate = NSPredicate(format: "ANY artist LIKE %@", artist)
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            artistPredicate
        ])
        
        do {
            let records = try self.container.viewContext.fetch(request)
            self.logger.trace("Fetched \(records.count) records")
            
            var snapshot = NSDiffableDataSourceSnapshot<Section, Record>()
            snapshot.appendSections([.main])
            snapshot.appendItems(records)
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

