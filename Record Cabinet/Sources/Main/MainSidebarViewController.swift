//
//  MainSidebarViewController.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 19.03.22.
//

import UIKit

class MainSidebarViewController: UIViewController {
    
    private enum SidebarItemType: Int {
        case header
        case expandableRow
        case row
    }
    
    private enum SidebarSection: Int {
        case search
        case library
    }
    
    private struct SidebarItem: Hashable, Identifiable {
        let id: UUID
        let type: SidebarItemType
        let title: String
        let subtitle: String?
        let image: UIImage?
        
        static func header(title: String, id: UUID = UUID()) -> Self {
            return SidebarItem(id: id, type: .header, title: title, subtitle: nil, image: nil)
        }
        
        static func expandableRow(title: String, subtitle: String?, image: UIImage?, id: UUID = UUID()) -> Self {
            return SidebarItem(id: id, type: .expandableRow, title: title, subtitle: subtitle, image: image)
        }
        
        static func row(title: String, subtitle: String?, image: UIImage?, id: UUID = UUID()) -> Self {
            return SidebarItem(id: id, type: .row, title: title, subtitle: subtitle, image: image)
        }
    }
    
    private struct RowIdentifier {
        static let search = UUID()
        static let library = UUID()
    }
    
    // MARK: - Properties
    
    private var collectionView: UICollectionView!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionView()
    }
}

// MARK: - CollectionView Configuration and Layout

extension MainSidebarViewController {
    
    func configureCollectionView() {
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.createLayout())
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.backgroundColor = .systemBackground
        self.collectionView.delegate = self
        self.view.addSubview(self.collectionView)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout() { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
            configuration.showsSeparators = false
            configuration.headerMode = .firstItemInSection
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            
            return section
        }
        return layout
    }
}

// MARK: - UICollectionViewDelegate

extension MainSidebarViewController: UICollectionViewDelegate {
    
}
