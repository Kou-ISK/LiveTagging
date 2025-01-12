//
//  TimelineItem.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/11.
//

import Foundation
import SwiftData
import AVFoundation

@Model
final class TimelineItem{
    var id: UUID
    var timeStamp: Double
    var itemLabel: String
    
    init(id: UUID, timeStamp: Double, itemLabel: String) {
        self.id = id
        self.timeStamp = timeStamp
        self.itemLabel = itemLabel
    }
}
