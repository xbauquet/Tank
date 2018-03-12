//
//  GHNotificationWebService.swift
//  Tank
//
//  Created by Work on 27/02/2018.
//  Copyright © 2018 xbauquet. All rights reserved.
//

import Foundation

protocol GHNotificationDelegate: NSObjectProtocol {
    func found(notifications: [GHNotification])
    func onFailure(_ error: Error?)
}

class GHNotificationWebService: NSObject {
    private static var delegates = [GHNotificationDelegate]()
    
    private static var lastCall: String?
    // 1 min
    private static var time = 60.0 {
        didSet {
            GHNotificationWebService.timer?.invalidate()
            GHNotificationWebService.timer = Timer.scheduledTimer(timeInterval: GHNotificationWebService.time, target: self, selector: #selector(start), userInfo: nil, repeats: true)
        }
    }
    
    private static var timer: Timer?
    private static var notifications = [GHNotification]()
    private var authManager = GHAuthManager()
    
    func register(_ delegate: GHNotificationDelegate) {
        GHNotificationWebService.delegates.append(delegate)
        delegate.found(notifications: GHNotificationWebService.notifications)
    }
    
    func unregister(_ delegate: GHNotificationDelegate) {
        GHNotificationWebService.delegates = GHNotificationWebService.delegates.filter { $0 !== delegate }
    }
    
    override init() {
        super.init()
        if GHNotificationWebService.timer == nil {
            startTimer()
            start()
        }
    }
    
    private func startTimer() {
        GHNotificationWebService.timer = Timer.scheduledTimer(timeInterval: GHNotificationWebService.time, target: self, selector: #selector(start), userInfo: nil, repeats: true)
    }
    
    @objc func start() {
        if let token = authManager.getToken() {
            get(token: token, url: "https://api.github.com/notifications")
        } else {
            authManager.disconnect()
        }
    }
    
    func get(token:String, url: String) {
        print("GET*******" + Date().description)
        URLCache.shared.removeAllCachedResponses()
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: url) else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        request.addValue("token " + token, forHTTPHeaderField: "Authorization")
        if let lastCall = GHNotificationWebService.lastCall {
            request.addValue("If-Modified-Since", forHTTPHeaderField: lastCall)
        }
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error == nil {
                let json = self.dataToJson(data)
                guard let httpUrlResponse = response as? HTTPURLResponse else {
                    self.onFailure(nil)
                    return
                }
                GHNotificationWebService.lastCall = httpUrlResponse.allHeaderFields["Date"] as? String
                if let interval = httpUrlResponse.allHeaderFields["X-Poll-Interval"] as? Double, interval != GHNotificationWebService.time {
                    GHNotificationWebService.time = interval
                }

                self.onSuccess(json: json, response: httpUrlResponse)
            } else {
                self.onFailure(error)
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    
    func onSuccess(json: Any?, response: HTTPURLResponse) {
        if response.statusCode == 200 {
            DispatchQueue.main.async {
                var notifications = [GHNotification]()
                if let JSON = json as? [[String:Any]] {
                    for notif in JSON {
                        let notification = GHNotification(notif: notif)
                        notifications.append(notification)
                    }
                }
                GHNotificationWebService.notifications = notifications
                for delegate in GHNotificationWebService.delegates {
                    delegate.found(notifications: GHNotificationWebService.notifications)
                }
            }
        } else {
            onFailure(nil)
        }
    }
    
    func dataToJson(_ data: Data?) -> Any? {
        let JSON: Any?
        do {
            JSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            return JSON
        } catch {
            return nil
        }
    }
    
    func onFailure(_ error: Error?) {
        DispatchQueue.main.async {
            for delegate in GHNotificationWebService.delegates {
                delegate.onFailure(error)
            }
        }
    }
}
