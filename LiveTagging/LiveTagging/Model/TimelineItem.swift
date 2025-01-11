//
//  TimelineItem.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/11.
//

import Foundation
import SwiftData

@Model
final class TimelineItem{
    var id: UUID
    var timeStamp: TimeInterval
    var itemLabel: String
    var videoItem: VideoItem // 逆参照
    
    init(id: UUID, timeStamp: TimeInterval, itemLabel: String, videoItem: VideoItem) {
        self.id = id
        self.timeStamp = timeStamp
        self.itemLabel = itemLabel
        self.videoItem = videoItem
    }
}
