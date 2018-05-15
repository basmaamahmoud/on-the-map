//
//  StudentsInformations.swift
//  OnTheMap
//
//  Created by Basma Ahmed Mohamed Mahmoud on 3/23/18.
//  Copyright © 2018 Basma Ahmed Mohamed Mahmoud. All rights reserved.
//

import Foundation


struct StudentInf {
    
    var firstName: String
    var lastName: String
    var longitude: Double
    var latitude: Double
    var mediaUrl: String
    var mapString: String
    var objectId: String
    var uniqueKey: String
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    
    //Construct a student from a dictionary
    init(dictionary: [String : AnyObject]) {
        
        firstName = dictionary["firstName"] as! String!
        lastName = dictionary["lastName"] as! String!
        longitude = dictionary["longitude"] as! Double
        latitude = dictionary["latitude"] as! Double
        mediaUrl = dictionary["mediaURL"] as! String!
        mapString = dictionary["mapString"] as! String!
        objectId = dictionary["objectId"] as! String!
        uniqueKey = dictionary["uniqueKey"] as! String!
        
    }
}
