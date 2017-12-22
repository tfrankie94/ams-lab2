//
//  Message.swift
//  lab2
//
//  Created by Tomasz Frankiewicz on 15/12/2017.
//  Copyright © 2017 Tomasz Frankiewicz. All rights reserved.
//

import Foundation

struct Message {
    
    var id: Int?
    var timestamp: Date
    var name : String
    var message : String
    
    init(id: Int? = nil, timestamp: Date = Date(), name: String, message: String) {
        self.id = id
        self.timestamp = timestamp
        self.name = name
        self.message = message
    }
    
}
