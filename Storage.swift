//
//  Storage.swift
//  OnTheMap
//
//  Created by Basma Ahmed Mohamed Mahmoud on 3/23/18.
//  Copyright © 2018 Basma Ahmed Mohamed Mahmoud. All rights reserved.
//

import Foundation

class Storage {
    
    // Current logged in user
    var user: UserMe? = nil
    
    // Student for current user
    var student: StudentInf? = nil
    
    // Student list for map and table
    var students: [StudentInf] = [StudentInf]()
    

    //Return the singleton instance of Storage
    class var shared: Storage {
        struct Static {
            static let instance: Storage = Storage()
        }
        return Static.instance
    }
}
