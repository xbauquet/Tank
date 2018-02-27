//
//  MenuViewController.swift
//  Tank
//
//  Created by Work on 27/02/2018.
//  Copyright © 2018 xbauquet. All rights reserved.
//

import Foundation
import Cocoa

class MenuViewController: NSViewController {
    
    var ghAuthManger = GHAuthManager()
    
    @IBAction func disconnectGHAction(_ sender: Any) {
        ghAuthManger.disconnect()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        NSApplication.shared.terminate(0)
    }
    
    static func get() -> MenuViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("MenuViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? MenuViewController else {
            fatalError("Why cant i find MenuViewController? - Check Main.storyboard") // TODO
        }
        return viewcontroller
    }
}
