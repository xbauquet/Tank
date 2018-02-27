//
//  GHAuthManager.swift
//  Tank
//
//  Created by Work on 25/02/2018.
//  Copyright © 2018 xbauquet. All rights reserved.
//
import Foundation

protocol GHConnectionDelegate: NSObjectProtocol {
    func connected()
    func disconnected()
    func connectionError()
}

class GHAuthManager: NSObject {
    
    private static var delegates = [GHConnectionDelegate]()
    
    override init(){
        super.init()
    }
    
    init(delegate: GHConnectionDelegate) {
        GHAuthManager.delegates.append(delegate)
    }
    
    func register(delegate: GHConnectionDelegate) {
        GHAuthManager.delegates.append(delegate)
    }
    
    func unregister(_ delegate: GHConnectionDelegate) {
        GHAuthManager.delegates = GHAuthManager.delegates.filter { $0 !== delegate }
    }
    
    private static let TOKEN_KEY = "github_token"
    
    private var token: String?
    
    func validate(token: String){
        self.token = token
        get(url: "https://api.github.com/notifications")
    }
    
    func connect() {
        DispatchQueue.main.async {
            UserDefaults.standard.set(self.token, forKey: GHAuthManager.TOKEN_KEY)
            for delegate in GHAuthManager.delegates {
                delegate.connected()
            }
        }
    }
    
    func disconnect() {
        DispatchQueue.main.async {
            UserDefaults.standard.removeObject(forKey: GHAuthManager.TOKEN_KEY)
            for delegate in GHAuthManager.delegates {
                delegate.disconnected()
            }
        }
    }
    
    func connectionError() {
        DispatchQueue.main.async {
            for delegate in GHAuthManager.delegates {
                delegate.connectionError()
            }
        }
    }
    
    private func get(url: String) {
        URLCache.shared.removeAllCachedResponses()
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: url) else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        request.addValue("token " + token!, forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            DispatchQueue.main.async {
                if let httpUrlResponse = response as? HTTPURLResponse, error == nil && httpUrlResponse.statusCode == 200 {
                    self.connect()
                } else {
                    self.connectionError()
                }
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: GHAuthManager.TOKEN_KEY)
    }
}
