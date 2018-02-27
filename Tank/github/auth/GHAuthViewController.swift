//
//  GHAuthViewController.swift
//  Tank
//
//  Created by Work on 26/02/2018.
//  Copyright © 2018 xbauquet. All rights reserved.
//

import Foundation
import Cocoa

class GHAuthViewController: NSViewController, GHConnectionDelegate {
    
    @IBOutlet weak var tokenField: NSTextField!
    
    private var authManager: GHAuthManager!
    
    override func viewDidLoad() {
        self.authManager = GHAuthManager(delegate: self)
    }
    
    @IBAction func okAction(_ sender: Any) {
        if tokenField.stringValue != "" {
            authManager.validate(token: tokenField.stringValue)
        } else {
            connectionError()
        }
    }
    
    @IBAction func howToAction(_ sender: Any) {
        if let url = URL(string: "https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/"){
            NSWorkspace.shared.open(url)
        }
    }
    
    func connectionError() {
        tokenField.backgroundColor = NSColor.red
    }
    
    func connected() {
        // Do nothing
    }
    
    func disconnected() {
        // Do nothing
    }
}
