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
    private var dataSource: UICollectionViewDiffableDataSource<SidebarSection, SidebarItem>!
    
    var sceneDelegate: SceneDelegate?
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionView()
        self.configureDataSource()
        self.applyInitialSnapshot()
        
        // Select Library at start
        
        
    }
}

// MARK: - UICollectionView

extension MainSidebarViewController {
    
    func configureCollectionView() {
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.createLayout())
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sidebarItem = self.dataSource.itemIdentifier(for: indexPath) else { return }
    
        switch SidebarSection(rawValue: indexPath.section) {
        case .library:
            self.didSelectLibraryItem(sidebarItem, at: indexPath)
        case .search:
            self.didSelectSearchItem(sidebarItem, at: indexPath)
        case .none:
            self.collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    private func didSelectLibraryItem(_: SidebarItem, at indexPath: IndexPath) {
        guard
            let splitViewController = self.splitViewController
        else { return }
        
        let vcToShow = MainNavigationController(rootViewController: LibraryCollectionViewController())
        vcToShow.sceneDelegate = self.sceneDelegate
        
        splitViewController.setViewController(vcToShow, for: .secondary)
    }
    
    private func didSelectSearchItem(_: SidebarItem, at indexPath: IndexPath) {
        guard
            let splitViewController = self.splitViewController
        else { return }
        
        let vcToShow = MainNavigationController(rootViewController: SearchViewController())
        vcToShow.sceneDelegate = self.sceneDelegate
                                                
        splitViewController.setViewController(vcToShow, for: .secondary)
    }
    
}

// MARK: - UICollectionViewDiffableDataSource

extension MainSidebarViewController {
    
    func configureDataSource() {
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem> {
            (cell, indexPath, item) in
            
            var contentConfiguration = UIListContentConfiguration.sidebarHeader()
            contentConfiguration.text = item.title
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .subheadline)
            contentConfiguration.textProperties.color = .secondaryLabel
            
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.outlineDisclosure()]
        }
        
        let expandableRowRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem> {
            (cell, indexPath, item) in
            
            var contentConfiguration = UIListContentConfiguration.sidebarSubtitleCell()
            contentConfiguration.text = item.title
            contentConfiguration.secondaryText = item.subtitle
            contentConfiguration.image = item.image
            
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.outlineDisclosure()]
        }
        
        let rowRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem> {
            (cell, indexPath, item) in
            
            var contentConfiguration = UIListContentConfiguration.sidebarSubtitleCell()
            contentConfiguration.text = item.title
            contentConfiguration.secondaryText = item.subtitle
            contentConfiguration.image = item.image
            
            cell.contentConfiguration = contentConfiguration
        }
        
        self.dataSource = UICollectionViewDiffableDataSource<SidebarSection, SidebarItem>(collectionView: self.collectionView) { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell in
            switch itemIdentifier.type {
            case .header:
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: itemIdentifier)
            case .expandableRow:
                return collectionView.dequeueConfiguredReusableCell(using: expandableRowRegistration, for: indexPath, item: itemIdentifier)
            case .row:
                return collectionView.dequeueConfiguredReusableCell(using: rowRegistration, for: indexPath, item: itemIdentifier)
            }
        }
    }
    
    private func librarySnapshot() -> NSDiffableDataSourceSectionSnapshot<SidebarItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<SidebarItem>()
        
        let header = SidebarItem.header(title: "SIDEBAR_LIBRARY_HEADER".localized())
        let items: [SidebarItem] = [
            .row(title: "SIDEBAR_LIBRARY_ALL".localized(), subtitle: nil, image: UIImage(systemName: "square.stack")),
            .row(title: "SIDEBAR_LIBRARY_ARTISTS".localized(), subtitle: nil, image: UIImage(systemName: "music.mic")),
            .row(title: "SIDEBAR_LIBRARY_GENRE".localized(), subtitle: nil, image: UIImage(systemName: "tray.full"))
        ]
        
        snapshot.append([header])
        snapshot.expand([header])
        snapshot.append(items, to: header)
        
        return snapshot
    }
    
    #warning("Implement Search Bar for Mac Catalyst")
    private func searchSnapshot() -> NSDiffableDataSourceSectionSnapshot<SidebarItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<SidebarItem>()
        
        let items: [SidebarItem] = [
            .row(title: "SIDEBAR_SEARCH".localized(), subtitle: nil, image: UIImage(systemName: "magnifyingglass"))
        ]
        
        snapshot.append(items)
        snapshot.expand(items)
        
        return snapshot
    }
    
    private func applyInitialSnapshot() {
        self.dataSource.apply(self.searchSnapshot(), to: .search, animatingDifferences: false)
        self.dataSource.apply(self.librarySnapshot(), to: .library, animatingDifferences: false)
    }
}
