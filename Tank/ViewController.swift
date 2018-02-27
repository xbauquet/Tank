//
//  ViewController.swift
//  Tank
//
//  Created by Work on 25/02/2018.
//  Copyright © 2018 xbauquet. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let menuPopover = NSPopover()
    
    @IBOutlet weak var menuButton: NSButton!
    
    @IBAction func menuAction(_ sender: Any) {
        if menuPopover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        menuPopover.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: NSRectEdge.maxX)
    }
    
    func closePopover(sender: Any?) {
        menuPopover.performClose(sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuPopover.contentViewController = MenuViewController.get()
        menuPopover.behavior = .transient
    }
    
    static func get() -> ViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("ViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ViewController else {
            fatalError("Why cant i find LoginViewController? - Check Main.storyboard")
            // TODO
        }
        return viewcontroller
    }


}

