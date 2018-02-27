//
//  WebcastParser.swift
//  Tank
//
//  Created by Work on 25/02/2018.
//  Copyright © 2018 xbauquet. All rights reserved.
//

import Foundation
import Alamofire
import SwiftSoup

protocol WebcastParserDelegate {
    func parsed(webcasts:[Webcast])
}

class WebcastParser {
    var delegate: WebcastParserDelegate?
    
    let url = "https://resources.github.com/webcasts/"
    
    func getWebcasts(delegate: WebcastParserDelegate) {
        self.delegate = delegate
        Alamofire.request(url).responseString { response in
            if let html = response.result.value {
                let webcasts = self.parseHTML(html: html)
                delegate.parsed(webcasts: webcasts)
            }
        }
    }
    
    func parseHTML(html: String) -> [Webcast] {
        
        var webcasts = [Webcast]()
        
        do {
            let doc = try SwiftSoup.parse(html)
            let listOfLi = try doc.select("ul").first()?.select("li").array() ?? [Element]()
            for element in listOfLi {
                let webcast = Webcast()
                webcast.imageLink = try element.select("img").attr("src")
                webcast.date = try element.select("p").first()?.text()
                webcast.description = try element.select("p").array()[1].text()
                let h3 = try element.select("h3").first()
                webcast.url = try h3?.select("a").attr("href")
                webcast.title = try h3?.select("a").text()
                webcasts.append(webcast)
            }
        } catch {
            Issue(title: "WebcastParser - error while parsing the webcasts", body: "Url =\(url)").send()
        }
        return webcasts
    }
}
