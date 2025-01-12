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
    var localIdentifier: String? // PHAsset のローカル識別子を保存
    var videoURL: URL?
    @Relationship var timeline: [TimelineItem]
    
    init(id: UUID, videoTitle: String, localIdentifier: String? = nil, videoURL: URL? = nil) {
        self.id = id
        self.videoTitle = videoTitle
        self.localIdentifier = localIdentifier
        self.videoURL = videoURL
        self.timeline = []
    }
}
