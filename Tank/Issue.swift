//
//  Issue.swift
//  Tank
//
//  Created by Work on 27/02/2018.
//  Copyright © 2018 xbauquet. All rights reserved.
//

import Foundation

class Issue {
    
    private let url = "https://api.github.com/repos/xbauquet/Tank/issues"
    private let token = "711252b5dce20962f0068208b42de39492792a13"
    let label = "bug"
    var title: String!
    var body: String!
    
    var json: String {
        get {
            var string = "{\"title\":\"\(self.title!)\", "
            string += "\"body\":\"\(self.body!)\", "
            string += "\"labels\":[\"\(self.label)\"]}"
            return string
        }
    }
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
    
    func send() {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = URL(string: url) else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("token " + token, forHTTPHeaderField: "Authorization")
        request.httpBody = json.data(using: .utf8)
        let task = session.dataTask(with: request, completionHandler: {_,_,_ in })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
