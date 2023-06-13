//
//  Category.swift
//  To-Do List
//
//  Created by Azimjonoff on 12/06/23.
//

import UIKit

class Category: NSObject, Codable {
    
    var name: String
    var items: [Item]
    
    init(name: String, items: [Item]) {
        self.name = name
        self.items = items
    }
}
