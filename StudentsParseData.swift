//
//  check.swift
//  OnTheMap
//
//  Created by Basma Ahmed Mohamed Mahmoud on 3/23/18.
//  Copyright © 2018 Basma Ahmed Mohamed Mahmoud. All rights reserved.
//

import Foundation

class StudentsParseData {
    
    private static let _instance = StudentsParseData()
    
    static var Instance: StudentsParseData{
        
        return _instance
    }
    
    func getStudentsInform(handler:@escaping (_ error: String?) -> Void){
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                // Handle error...
                handler("Connection Error")
                return
            }
            //print(String(data: data!, encoding: .utf8)!)
            let parsedResult: [String: AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject]
                
            } catch {
                print("Error parsing result as JSON")
                handler("Cant download Student data")
                return
            }
            guard let results = parsedResult!["results"] as? [[String : AnyObject]] else {
                print("Can't find [results] in response")
                handler("Can't find students information response")
                return
            }
            var students: [StudentInf] = []
            
            for result in results {
                
                // here i will check if the studenta data contain all of our parameters which are 8 parameters plus 2 extra pramateres we dont use, Note: some data from students doesnt contain website url? or firstname?? thats weared, thats why i checked 8 parameters
                let x = result.count
                if x == 10{
                    students.append(StudentInf(dictionary: result)) 
                    
                }
            }
            Storage.shared.students = students
            
            handler(nil)
            
        }
        task.resume()
        
    }
 
}
