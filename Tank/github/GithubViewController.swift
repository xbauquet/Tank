//
//  GithubViewController.swift
//  Tank
//
//  Created by Work on 26/02/2018.
//  Copyright © 2018 xbauquet. All rights reserved.
//

import Foundation
import Cocoa

class GithubViewController: NSViewController, GHConnectionDelegate {
    
    @IBOutlet weak var authContainer: NSView!
    @IBOutlet weak var notificationContainer: NSView!
    
    var authManager: GHAuthManager!
    
    override func viewDidLoad() {
        authManager = GHAuthManager(delegate: self)
        
        if authManager.getToken() != nil {
            showNotifContainer()
        } else {
            showAuthContainer()
        }
    }
    
    func connected() {
        showNotifContainer()
    }
    
    func disconnected() {
        showAuthContainer()
    }
    
    func connectionError() {
        // Do nothing
    }
    
    private func showAuthContainer() {
        authContainer.isHidden = false
        notificationContainer.isHidden = true
    }
    
    private func showNotifContainer() {
        authContainer.isHidden = true
        notificationContainer.isHidden = false
    }
}
