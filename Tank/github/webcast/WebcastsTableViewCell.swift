//
//  WebcastsTableViewCell.swift
//  Tank
//
//  Created by Work on 25/02/2018.
//  Copyright © 2018 xbauquet. All rights reserved.
//

import Foundation
import Cocoa
import WebKit

class WebcastsTableViewCell: NSTableCellView {
    
    @IBOutlet weak var dateLabel: NSTextField!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLabel: NSTextField!
    
    var url: String?
    
    func update(webcast: Webcast) {
        
        let stringUrl = "https://resources.github.com" + webcast.imageLink!
        let html = "<img height=\"30\" width=\"30\" style=\"object-fit:scale-down;\" src=\"\(stringUrl)\">"
        webView.loadHTMLString(html, baseURL: nil)
        dateLabel.stringValue = webcast.date!
        titleLabel.stringValue = webcast.title!
        url = webcast.url
        let gesture = NSClickGestureRecognizer(target: self, action: #selector(tap(_:)))
        self.addGestureRecognizer(gesture)
    }
    
    var cursor = NSCursor.openHand
    
    open override func resetCursorRects() {
        addCursorRect(self.bounds, cursor: cursor)
    }
    
    @objc func tap(_ sender: NSClickGestureRecognizer) {
        if let url = URL(string: "https://resources.github.com" + self.url!){
            NSWorkspace.shared.open(url)
        }
    }
}
