//
//  CustomTagItem.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/11.
//

import Foundation
import SwiftData

@Model
final class CustomTagItem{
    var id: UUID
    var itemLabel: String
    
    init(id: UUID, itemLabel: String) {
        self.id = id
        self.itemLabel = itemLabel
    }
}
