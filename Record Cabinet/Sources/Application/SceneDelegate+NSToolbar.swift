//
//  SceneDelegate+NSToolbar.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 19.03.22.
//

import Foundation

#if targetEnvironment(macCatalyst)
import AppKit

extension SceneDelegate: NSToolbarDelegate {
    
    func toolbarItems() -> [NSToolbarItem.Identifier] {
        return [.toggleSidebar]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarItems()
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarItems()
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        return NSToolbarItem(itemIdentifier: itemIdentifier)
    }
}
#endif
