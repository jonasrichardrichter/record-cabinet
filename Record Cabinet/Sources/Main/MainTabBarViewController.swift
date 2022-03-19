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
        
        self.viewControllers = [recordsVC]
        self.tabBar.tintColor = UIColor(named: "AccentColor")
    }
}
