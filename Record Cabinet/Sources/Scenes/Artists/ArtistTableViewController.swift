//
//  ArtistTableViewController.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 04.05.22.
//

import UIKit
import CoreData
import Logging

class ArtistTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var logger = Logger(for: "ArtistTableViewController")
    
    var container: NSPersistentContainer!
    
    var artists: [String] = []
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
#if DEBUG
        self.logger.logLevel = .trace
#endif
        
        // Core Data
        self.container = NSPersistentContainer(name: "Record_Cabinet")
        
        self.container.loadPersistentStores { storeDescription, error in
            if let error = error {
                self.logger.error("Unresolved error: \(error)")
                
                let alert = UIAlertController(title: "ALERT_ERROR".localized(), message: "ALERT_ERROR_MESSAGE".localized(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: .cancel))
                
                self.present(alert, animated: true)
            }
        }
        
        // Fetch data and fill tableView
        
        do {
            try self.loadData()
            self.tableView.reloadData()
        } catch {
            self.logger.error("An error happened: \(error.localizedDescription)")
            
            let alert = UIAlertController(title: "ALERT_ERROR".localized(), message: "ALERT_ERROR_MESSAGE".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: .cancel))
            
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - Load data
    
    func loadData() throws {
        let fetchRequest = Record.createFetchRequest()
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.propertiesToGroupBy = ["artist"]
        fetchRequest.propertiesToFetch = ["artist"]
        fetchRequest.resultType = .dictionaryResultType
        
        let results = try self.container.viewContext.fetch(fetchRequest) as AnyObject as! [Dictionary<String, String>]
        
        var fetchedArtists: [String] = []
        
        for result in results {
            fetchedArtists.append(result["artist"] ?? "error")
        }
        
        self.artists = fetchedArtists
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.artists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")

        var content = cell.defaultContentConfiguration()
        
        content.text = self.artists[indexPath.row]
        
        cell.contentConfiguration = content
        
        return cell
    }
}
