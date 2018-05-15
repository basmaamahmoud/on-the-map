//
//  UserMe.swift
//  OnTheMap
//
//  Created by Basma Ahmed Mohamed Mahmoud on 3/23/18.
//  Copyright © 2018 Basma Ahmed Mohamed Mahmoud. All rights reserved.
//

import Foundation

struct UserMe {
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var link: String
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    init(uniqueKey: String, firstName: String, lastName: String, link: String) {
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.link = link
    }
}
