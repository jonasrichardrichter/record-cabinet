//
//  RecordsCollectionViewController.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 17.03.22.
//

import UIKit
import Logging
import CoreData

class LibraryCollectionViewController: UIViewController {
    
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

// MARK: - Layout
extension LibraryCollectionViewController {
    
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
extension LibraryCollectionViewController {
    
    func createAddRecordButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "RECORDS_COLLECTION_ADD_CONTENT_BUTTON".localized(), image: UIImage(systemName: "plus.circle.fill"), primaryAction: nil, menu: UIMenu(title: "RECORDS_COLLECTION_ADD_CONTENT_BUTTON".localized(), image: nil, identifier: nil, options: [], children: [
            UIAction(title: "RECORDS_COLLECTION_ADD_RECORD_BUTTON".localized(), image: nil, handler: { action in
                let addRecordVC = AddRecordViewController()
                addRecordVC.delegate = self
                let sheetController = addRecordVC.sheetPresentationController
                sheetController?.prefersGrabberVisible = false
                sheetController?.detents = [.large()]
                
                self.present(UINavigationController(rootViewController: addRecordVC), animated: true)
            }),
            UIAction(title: "Demodaten einfügen", image: nil, handler: { action in
                self.addDemoData()
                self.logger.trace("Tapped 'Add Record' button")
            })
        ]))
    }
    
    func addDemoData() {
        let demoRecord = Record(context: self.container.viewContext)
        demoRecord.name = "Großartiges Album"
        demoRecord.artist = "Großartiger Künstler"
        demoRecord.releaseDate = Date()
        
        self.saveContext()
        self.loadSavedData()
        
        self.logger.debug("Added demo data")
    }
}

extension LibraryCollectionViewController: AddRecordDelegate {
    func reloadData() {
        self.loadSavedData()
    }
}
