//
//  RecordsCollectionViewController.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 17.03.22.
//

import UIKit
import Logging
import CoreData

private let reuseIdentifier = "Cell"

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

        // Core Data
        container = NSPersistentContainer(name: "Record_Cabinet")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                self.logger.error("Unresolved error: \(error)")
            }
        }
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
        self.tabBarItem = UITabBarItem(title: "RECORDS_COLLECTION_TITLE".localized(), image: UIImage(systemName: "square.stack.fill"), selectedImage: UIImage(systemName: "square.stack.fill"))
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
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
