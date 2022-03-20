//
//  MainNavigationController.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 20.03.22.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    var sceneDelegate: SceneDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
#if targetEnvironment(macCatalyst)
        self.isNavigationBarHidden = true
        
        self.sceneDelegate?.window?.windowScene?.title = self.topViewController?.title
#endif
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
#if targetEnvironment(macCatalyst)
        self.sceneDelegate?.window?.windowScene?.title = self.topViewController?.title
#endif
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
#if targetEnvironment(macCatalyst)
        self.sceneDelegate?.window?.windowScene?.title = self.topViewController?.title
#endif
    }
}
