//
//  ArtistTableViewController.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 04.05.22.
//

import UIKit
import CoreData
import Logging
import Algorithms

class ArtistTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var logger = Logger(for: "ArtistTableViewController")
    
    var container: NSPersistentContainer!
    
    var artists: [String] = []
    var artistsFirstLetter: [Character] = []
    
    // MARK: - Init
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
#if DEBUG
        self.logger.logLevel = .trace
#endif
        
        self.title = "ARTISTS_TITLE".localized()
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
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
            if let artistName = result["artist"] {
                fetchedArtists.append(artistName)
                if let firstCharacter = artistName.first {
                    self.artistsFirstLetter.append(firstCharacter)
                }
            }
            
        }
        
        self.artists = fetchedArtists
        self.artistsFirstLetter = Array(self.artistsFirstLetter.uniqued())
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.artistsFirstLetter.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let startingCharacter = self.artistsFirstLetter[section]
        let filteredArtists = self.artists.filter({ $0.hasPrefix(String(startingCharacter)) })
        
        return filteredArtists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        var content = cell.defaultContentConfiguration()
        
        let startingCharacter = self.artistsFirstLetter[indexPath.section]
        let filteredArtists = self.artists.filter({ $0.hasPrefix(String(startingCharacter)) })
        let artist = filteredArtists[indexPath.row]
        
        content.text = artist
        cell.accessoryType = .disclosureIndicator
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(self.artistsFirstLetter[section])
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.artistsFirstLetter.map { String($0) }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let startingCharacter = self.artistsFirstLetter[indexPath.section]
        let filteredArtists = self.artists.filter({ $0.hasPrefix(String(startingCharacter)) })
        let artist = filteredArtists[indexPath.row]
        
        let vcToPush = ArtistRecordsCollectionViewController(for: artist)
        
        self.navigationController?.pushViewController(vcToPush, animated: true)
    }
}
