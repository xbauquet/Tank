//
//  Webcast.swift
//  Tank
//
//  Created by Work on 25/02/2018.
//  Copyright © 2018 xbauquet. All rights reserved.
//

import Foundation

class Webcast: Equatable {
    var imageLink: String?
    var date: String?
    var description: String?
    var url: String?
    var title: String?
    
    static func ==(lhs: Webcast, rhs: Webcast) -> Bool {
        return lhs.title == rhs.title && lhs.date == rhs.date && lhs.description == rhs.description && lhs.imageLink == rhs.imageLink && lhs.url == rhs.url
    }
}
