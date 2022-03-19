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
        
        let recordsVC = UINavigationController(rootViewController: RecordsCollectionViewController())
        recordsVC.tabBarItem = UITabBarItem(title: "RECORDS_COLLECTION_TITLE".localized(), image: UIImage(systemName: "square.stack.fill"), selectedImage: UIImage(systemName: "square.stack.fill"))
        
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem = UITabBarItem(title: "SEARCH_TITLE".localized(), image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        
        self.viewControllers = [recordsVC, searchVC]
        self.tabBar.tintColor = UIColor(named: "AccentColor")
    }
}
