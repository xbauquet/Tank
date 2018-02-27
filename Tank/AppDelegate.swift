//
//  AppDelegate.swift
//  Tank
//
//  Created by Work on 25/02/2018.
//  Copyright © 2018 xbauquet. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, GHNotificationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.variableLength)
    let popover = NSPopover()
    
    let ghNotificationWS = GHNotificationWebService()
    var githubNotifications = [GHNotification]()
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.action = #selector(buttonAction(_:))
        }
        popover.contentViewController = ViewController.get()
        popover.behavior = .transient
        
        ghNotificationWS.register(self)
    }

    @objc func buttonAction(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
    }

    func found(notifications: [GHNotification]) {
        githubNotifications = notifications
        updateIcon()
    }
    
    func onFailure(_ error: Error?) {
        updateIcon()
    }
    
    func updateIcon() {
        if let button = statusItem.button {
            let view = IconView(frame: NSRect(x: 0, y: 0, width: 58, height: 32))
            view.update(githubNotifications.count)
            button.image = view.image()
        }
    }
}

