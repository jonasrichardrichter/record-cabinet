//
//  MainTabBarViewController.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 17.03.22.
//

import UIKit
import SwiftUI

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recordsVC = UINavigationController(rootViewController: LibraryCollectionViewController())
        recordsVC.tabBarItem = UITabBarItem(title: "RECORDS_COLLECTION_TITLE".localized(), image: UIImage(systemName: "square.stack.fill"), selectedImage: UIImage(systemName: "square.stack.fill"))
        
        let searchVC = UIHostingController(rootView: SearchView())
        searchVC.tabBarItem = UITabBarItem(title: "SEARCH_TITLE".localized(), image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        
        self.viewControllers = [recordsVC, searchVC]
        self.tabBar.tintColor = UIColor(named: "AccentColor")
    }
}
