//
//  RecordsCollectionViewController.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 17.03.22.
//

import UIKit
import Logging
import CoreData

class RecordsCollectionViewController: UIViewController {

    enum Section {
        case main
    }
    
    // MARK: - Properties
    
    var logger = Logger(for: "RecordsCollectionViewController")
    
    var container: NSPersistentContainer!
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Record>!
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        self.logger.logLevel = .trace
        #endif
        
        self.setupView()
        self.configureDataSource()
        self.createAddRecordButton()

        // Core Data
        container = NSPersistentContainer(name: "Record_Cabinet")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                self.logger.error("Unresolved error: \(error)")
            }
        }
        
        self.loadSavedData()
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    func loadSavedData() {
        let request  = Record.createFetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            let records = try self.container.viewContext.fetch(request)
            self.logger.trace("Fetched \(records.count) records")
            
            var snapshot = NSDiffableDataSourceSnapshot<Section, Record>()
            snapshot.appendSections([.main])
            snapshot.appendItems(records)
            self.dataSource.apply(snapshot, animatingDifferences: true)
            
        } catch {
            self.logger.error("An error happened: \(error)")
        }
    }
    
    // MARK: - View Setup
    
    func setupView() {
        self.title = "RECORDS_COLLECTION_TITLE".localized()
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: self.createLayout())
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.backgroundColor = .systemBackground
        self.view.addSubview(self.collectionView)
        self.logger.trace("View setup successful")
    }
}

// MARK: - Layout
extension RecordsCollectionViewController {
    
    // Two Item Grid
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        #warning("Fix height not correct")
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(210))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

        let spacing = CGFloat(20)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        self.logger.trace("Created UICollectionViewLayout")
        
        return layout
    }
    
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

// MARK: - Add Record Button
#warning("Incomplete implementation")
extension RecordsCollectionViewController {
    
    func createAddRecordButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "RECORDS_COLLECTION_ADD_RECORD_BUTTON".localized(), image: UIImage(systemName: "plus.circle.fill"), primaryAction: UIAction(handler: { action in
            self.addDemoData()
            self.logger.trace("Tapped 'Add Record' button")
        }), menu: nil)
    }
    
    func addDemoData() {
        let demoRecord = Record(context: self.container.viewContext)
        demoRecord.name = "Test Record"
        demoRecord.artist = "Test Artist"
        demoRecord.releaseDate = Date()
        
        self.saveContext()
        self.loadSavedData()
        
        self.logger.debug("Added demo data")
    }
}
