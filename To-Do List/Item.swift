//
//  Item.swift
//  To-Do List
//
//  Created by Azimjonoff on 12/06/23.
//

import UIKit

class Item: NSObject, Codable {
    var name: String
    var done: Bool
    
    init(name: String, done: Bool) {
        self.name = name
        self.done = done
    }
}
