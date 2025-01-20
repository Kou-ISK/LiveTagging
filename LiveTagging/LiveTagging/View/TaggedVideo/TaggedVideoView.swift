//
//  TaggedVideoView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/12.
//

import SwiftUI
import AVKit
import Photos

struct TaggedVideoView: View {
    @Binding var videoItem: VideoItem
    
    @State var player: AVPlayer
        
        init(videoItem: Binding<VideoItem>) {
            self._videoItem = videoItem
            self._player = State(initialValue: AVPlayer(url: videoItem.wrappedValue.videoURL ?? URL(string: "https://www.example.com/sample.mp4")!))
        }
    
    var body: some View {
        ZStack {
            VideoPlayer(player: player)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack{
                    Spacer()
                    // タイムライン共有リンク
                    ShareLink(item: generateTimelineText(from: videoItem.timeline)) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                Spacer()
                HStack{
                    TaggedVideoTimelineView(timeline: $videoItem.timeline, player: player)
                        .frame(maxHeight: 150)
                    Spacer()
                }
            }
        }
    }
    
    private func generateTimelineText(from timeline: [TimelineItem]) -> String {
        guard !timeline.isEmpty else {
            return "タイムラインは空です。"
        }
        return timeline.map { "\(formatTime($0.timeStamp)) \($0.itemLabel)" }.joined(separator: "\n")
    }
    
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct TaggedVideoView_Previews: PreviewProvider {
    static var previews: some View {
        // プレビュー用のサンプルデータを作成
        let sampleVideoItem = VideoItem(id: UUID(), videoTitle: "サンプルビデオ", videoURL: URL(filePath: "/Users/isakakou/Desktop/dynamic2.mov"))
        sampleVideoItem.timeline = [
            TimelineItem(id: UUID(), timeStamp: 1.023, itemLabel: "タックル"),
            TimelineItem(id: UUID(), timeStamp: 3.023, itemLabel: "タックル")
        ]
        return TaggedVideoView(videoItem: .constant(sampleVideoItem))
    }
}
