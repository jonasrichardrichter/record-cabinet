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
        
        self.setupView()
        self.configureDataSource()

        // Core Data
        container = NSPersistentContainer(name: "Record_Cabinet")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                self.logger.error("Unresolved error: \(error)")
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Record>()
        snapshot.appendSections([.main])
        
        let demoRecord = Record(context: self.container.viewContext)
        demoRecord.name = "Test Record"
        demoRecord.artist = "Test Artist"
        
        let demoRecord2 = Record(context: self.container.viewContext)
        demoRecord2.name = "Test Record"
        demoRecord2.artist = "Test Artist"

        let demoRecord3 = Record(context: self.container.viewContext)
        demoRecord3.name = "Test Record"
        demoRecord3.artist = "Test Artist"

        snapshot.appendItems([demoRecord, demoRecord2, demoRecord3])
        self.dataSource.apply(snapshot, animatingDifferences: false)
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
    
    // MARK: - View Setup
    
    func setupView() {
        self.title = "RECORDS_COLLECTION_TITLE".localized()
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: self.createLayout())
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.backgroundColor = .systemBackground
        self.view.addSubview(self.collectionView)
    }
}

// MARK: - Layout
extension RecordsCollectionViewController {
    
    // Two Item Grid
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(210))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

        let spacing = CGFloat(20)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<RecordCollectionViewCell, Record> { (cell, indexPath, itemIdentifier) in
            cell.recordLabel.text = itemIdentifier.name
            cell.artistLabel.text = itemIdentifier.artist
        }
        
        self.dataSource = UICollectionViewDiffableDataSource<Section, Record>(collectionView: self.collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Record) -> UICollectionViewCell? in
            
            return self.collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
}
