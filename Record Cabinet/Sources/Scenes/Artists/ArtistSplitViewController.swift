//
//  ArtistSplitViewController.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 04.05.22.
//

import UIKit

class ArtistSplitViewController: UISplitViewController {

    init() {
        super.init(style: .doubleColumn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let artistTableVC = ArtistTableViewController(style: .insetGrouped)
        artistTableVC.view.backgroundColor = .gray
        
        let artistRecordCVC = UIViewController()
        artistRecordCVC.view.backgroundColor = .orange
        

        self.setViewController(UINavigationController(rootViewController: artistTableVC), for: .primary)
        self.setViewController(UINavigationController(rootViewController: artistRecordCVC), for: .secondary)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
