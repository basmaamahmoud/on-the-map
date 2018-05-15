//
//  OnTheMapFunc.swift
//  OnTheMap
//
//  Created by Basma Ahmed Mohamed Mahmoud on 3/24/18.
//  Copyright © 2018 Basma Ahmed Mohamed Mahmoud. All rights reserved.
//

import Foundation



class OnTheMapFunc{
    
    var sessionId: String? = nil
    var userId: String? = nil
    
    
    
    // Singleton instance of OnTheMapFunc
    static let shared = OnTheMapFunc()
    
    func createSession(username: String, password: String, handler:@escaping (_ error: String?) -> Void){
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                // handel error
                handler("Connection error")
                return
            }
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            let parsedResult: [String: AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as? [String: AnyObject]
                
            } catch {
                print("Error loading data")
                return
            }
            // Loging for ["account"]["key"]
            guard let account = parsedResult["account"] as? [String : AnyObject], let userId = account["key"] as? String else {
                handler("Username or password is incorrect")
                return
            }
            
            
            // Loging for ["session"]["id"]
            guard let session = parsedResult["session"] as? [String : AnyObject], let sessionId = session["id"] as? String else {
                handler("Username or password is incorrect")
                return
            }
            
            
            self.sessionId = sessionId
            self.userId = userId
            
            handler(nil)
            
        }
        task.resume()
        
    }
    
    
    func deleteSession(handler: @escaping (_ error: String?) -> Void){
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                // Handle error…
                handler("Connection error")
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            
            let parsedResult: [String: AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as? [String: AnyObject]
                
            } catch {
                handler("Error loading data")
                return
            }
            
            // Loging for ["session"]["id"]
            guard let session = parsedResult["session"] as? [String : AnyObject], let sessionId = session["id"] as? String else {
                handler("Error getting data")
                return
            }
            
            self.sessionId = sessionId
            self.userId = nil
            handler(nil)
            
        }
        
        task.resume()
    }
    
    
    func updateCurrentUser(latitude: Double, Longitude: Double,mediaURL: String, handler:@escaping (_ error: String?) -> Void){
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(Storage.shared.student?.objectId as! String)"
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"uniqueKey\": \"\(Storage.shared.student?.uniqueKey as! String)\", \"firstName\": \"\(Storage.shared.student?.firstName as! String)\", \"lastName\": \"\(Storage.shared.student?.lastName as! String)\",\"mapString\": \"\(Storage.shared.student?.mapString as! String)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(Longitude)}".data(using: .utf8)
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                // Handle error…
                handler(error as! String)
                return
            }
            let parsedResult: [String: AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject]
                
            } catch {
                print("Error parsing result as JSON")
                handler(error as! String)
                return
            }
            handler(nil)
        }
        
        task.resume()
    }
}
