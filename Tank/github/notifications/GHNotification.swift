//
//  GHNotification.swift
//  Tank
//
//  Created by Work on 27/02/2018.
//  Copyright © 2018 xbauquet. All rights reserved.
//

import Foundation

class GHNotification {
    var repo: String?
    var title: String?
    var type: String?
    var time: String?
    var url: String?
    
    init(notif: [String:Any]) {
        if let time = notif["updated_at"] as? String {
            self.time = time
        }
        
        if let subject = notif["subject"] as? [String:String] {
            if let title = subject["title"] {
                self.title = title
            }
            if let url = subject["url"] {
                self.url = url
            }
            if let type = subject["type"] {
                self.type = type
            }
        }
        
        if let repository = notif["repository"] as? [String:Any] {
            if let repo = repository["full_name"] as? String {
                self.repo = repo
            }
        }
    }
    
    func string() -> String {
        var text = repo! + ","
        text += title! + ", "
        text += type! + ", "
        text += time! + ", "
        return text + url!
    }
}
