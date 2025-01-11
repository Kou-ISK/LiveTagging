//
//  CustomTagItem.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/11.
//

import Foundation
import SwiftData

@Model
final class CustomTagSet{
    var id: UUID
    var tagSetName: String
    @Relationship var tags: [CustomTagItem]
    
    init(id: UUID, tagSetName: String, tags: [CustomTagItem]) {
        self.id = id
        self.tagSetName = tagSetName
        self.tags = []
    }
}
