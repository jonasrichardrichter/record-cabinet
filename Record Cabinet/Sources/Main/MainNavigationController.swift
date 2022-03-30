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
        self.setupMacCatalyst()
#endif
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
#if targetEnvironment(macCatalyst)
        self.setupMacCatalyst()
#endif
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        self.setupMacCatalyst()
    }
    
    func setupMacCatalyst() {
#if targetEnvironment(macCatalyst)
        self.sceneDelegate?.window?.windowScene?.title = self.topViewController?.title
        self.isNavigationBarHidden = true
#endif
    }
}
