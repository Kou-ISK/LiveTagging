//
//  VideoItem.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/11.
//

import Foundation
import SwiftData

@Model
final class VideoItem {
    var id: UUID
    var videoTitle: String
    var videoURL: URL
    @Relationship var timeline: [TimelineItem]
    
    init(id: UUID, videoTitle: String, videoURL: URL) {
        self.id = id
        self.videoTitle = videoTitle
        self.videoURL = videoURL
        self.timeline = []
    }
}
