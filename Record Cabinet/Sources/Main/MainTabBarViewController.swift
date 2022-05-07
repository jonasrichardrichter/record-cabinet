//
//  MainTabBarViewController.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 17.03.22.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recordsVC = UINavigationController(rootViewController: LibraryCollectionViewController())
        recordsVC.tabBarItem = UITabBarItem(title: "RECORDS_COLLECTION_TITLE".localized(), image: UIImage(systemName: "square.stack.fill"), selectedImage: UIImage(systemName: "square.stack.fill"))
        
        let artistVC = UINavigationController(rootViewController: ArtistTableViewController())
        artistVC.tabBarItem = UITabBarItem(title: "ARTISTS_TITLE".localized(), image: UIImage(systemName: "music.mic"), selectedImage: UIImage(systemName: "music.mic"))
        
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem = UITabBarItem(title: "SEARCH_TITLE".localized(), image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        
        self.viewControllers = [recordsVC, artistVC, searchVC]
        self.tabBar.tintColor = UIColor(named: "AccentColor")
    }
}
