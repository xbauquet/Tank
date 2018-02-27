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
        let gesture = NSClickGestureRecognizer(target: self, action: #selector(tap(_:)))
        self.addGestureRecognizer(gesture)
    }
    
    var cursor = NSCursor.openHand
    
    open override func resetCursorRects() {
        addCursorRect(self.bounds, cursor: cursor)
    }
    
    @objc func tap(_ sender: NSClickGestureRecognizer) {
        if let url = URL(string: self.url){
            NSWorkspace.shared.open(url)
        }
    }
}
