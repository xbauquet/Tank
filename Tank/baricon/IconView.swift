//
//  IconView.swift
//  Tank
//
//  Created by Work on 27/02/2018.
//  Copyright © 2018 xbauquet. All rights reserved.
//

import Foundation
import Cocoa
import Quartz

class IconView : NSView {
    
    @IBOutlet var view: NSView!
    
    @IBOutlet weak var ghLabel: NSTextField!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "IconView"), owner: self, topLevelObjects: nil)
        self.view.frame = self.bounds
        self.addSubview(self.view)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func update(_ ghNotifs: Int) {
        ghLabel.stringValue = "\(ghNotifs)"
    }
    
    func image() -> NSImage {
        let dataOfView = self.dataWithPDF(inside: self.bounds)
        return NSImage(data: dataOfView)!
    }
}
