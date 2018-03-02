//
//  GHTableViewCell.swift
//  Tank
//
//  Created by Work on 27/02/2018.
//  Copyright © 2018 xbauquet. All rights reserved.
//

import Foundation
import Cocoa

class GHTableViewCell: NSTableCellView {
    
    @IBOutlet weak var title: NSTextField!
    @IBOutlet weak var body: NSTextField!
    @IBOutlet weak var date: NSTextField!
    
    var url = "https://github.com/notifications"
    
    func update(notification: GHNotification) {
        title.stringValue = notification.repo!
        date.stringValue = notification.time!
        body.stringValue = notification.title!
    }
    
    var cursor = NSCursor.openHand
    
    open override func resetCursorRects() {
        addCursorRect(self.bounds, cursor: cursor)
    }
}
