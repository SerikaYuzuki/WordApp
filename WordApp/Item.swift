//
//  Item.swift
//  WordApp
//
//  Created by 柚木芹香☕️ on 2025/03/17.
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
