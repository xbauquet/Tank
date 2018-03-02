//
//  GHNotificationViewController.swift
//  Tank
//
//  Created by Work on 27/02/2018.
//  Copyright © 2018 xbauquet. All rights reserved.
//

import Foundation
import Cocoa

class GHNotificationViewController: NSViewController, GHNotificationDelegate, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    
    let webService = GHNotificationWebService()
    var notifications = [GHNotification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        webService.register(self)
    }
    
    func found(notifications: [GHNotification]) {
        self.notifications = notifications
        self.tableView.reloadData()
    }
    
    func onFailure(_ error: Error?) {
        found(notifications: [GHNotification]())
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "GHTableViewCell"), owner: self) as? GHTableViewCell {
            cell.update(notification: notifications[row])
            return cell
        }
        return NSTableCellView()
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 80
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        if let url = URL(string: "https://github.com/notifications"){
            NSWorkspace.shared.open(url)
        }
    }
}
