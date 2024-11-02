//
//  Item.swift
//  yearbar
//
//  Created by Prakash Pawar on 23/10/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
