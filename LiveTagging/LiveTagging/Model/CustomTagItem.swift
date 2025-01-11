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
    var tagSet: CustomTagSet
    
    init(id: UUID, timeStamp: TimeInterval, itemLabel: String, tagSet: CustomTagSet) {
        self.id = id
        self.itemLabel = itemLabel
        self.tagSet = tagSet
    }
}
