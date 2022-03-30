//
//  SceneDelegate+NSToolbar.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 19.03.22.
//

import Foundation
import UIKit

#if targetEnvironment(macCatalyst)
extension NSToolbarItem.Identifier {
    static let newItem = NSToolbarItem.Identifier("eu.jonasrichter.recordcabinet.newitem")
}

extension SceneDelegate: NSToolbarDelegate {
    
    func toolbarItems() -> [NSToolbarItem.Identifier] {
        return [.toggleSidebar, .flexibleSpace , .newItem]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarItems()
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarItems()
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        if itemIdentifier == .newItem {
            let barItem = UIBarButtonItem(title: "Neue Schallplatte hinzufügen", image: UIImage(systemName: "plus"), primaryAction: nil, menu: nil)
            let item = NSToolbarItem(itemIdentifier: itemIdentifier, barButtonItem: barItem)
            
            return item
        } else {
            return NSToolbarItem(itemIdentifier: itemIdentifier)
        }
    }
}
#endif
