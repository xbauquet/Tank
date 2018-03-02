//
//  GHWebcastViewController.swift
//  Tank
//
//  Created by Work on 25/02/2018.
//  Copyright © 2018 xbauquet. All rights reserved.
//

import Foundation
import Cocoa

class GHWebcastViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, WebcastParserDelegate {
    
    var webcasts = [Webcast]()
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear() {
        WebcastParser().getWebcasts(delegate: self)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return webcasts.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "WebcastsTableViewCell"), owner: self) as? WebcastsTableViewCell {
            cell.update(webcast: webcasts[row])
            return cell
        }
        return NSTableCellView()
    }
    
    func parsed(webcasts: [Webcast]) {
        self.webcasts = webcasts
        self.tableView.reloadData()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let webcast = webcasts[tableView.selectedRow]
        if let url = URL(string: "https://resources.github.com" + webcast.url!){
            NSWorkspace.shared.open(url)
        }
    }
}
