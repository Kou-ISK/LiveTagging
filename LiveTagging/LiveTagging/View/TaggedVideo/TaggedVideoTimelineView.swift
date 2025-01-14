//
//  TaggedVideoTimelineView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/13.
//

import SwiftUI
import AVFoundation

struct TaggedVideoTimelineView: View {
    @Binding var timeline: [TimelineItem]
    var player: AVPlayer
    
    var body: some View {
        ScrollView(.vertical){
            VStack(alignment:.leading){
                ForEach(timeline, id:\.id){item in
                    Button(action:{
                        let targetTime = CMTime(seconds: item.timeStamp, preferredTimescale: 600)
                        player.seek(to: targetTime)
                    }, label: {
                        HStack{
                            Text(formatTime(item.timeStamp))
                            Text(item.itemLabel)
                        }
                        .padding(4)
                        .foregroundColor(.white)
                    })
                }
            }
        }
        .background(.gray.opacity(0.2))
        .padding(.vertical, 32)
    }
    
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    TaggedVideoTimelineView(timeline: .constant([
        TimelineItem(id: UUID(), timeStamp: 1.023, itemLabel: "タックル"),
        TimelineItem(id: UUID(), timeStamp: 1.023, itemLabel: "タックル")
    ]), player: AVPlayer(url: URL(filePath: "/Users/isakakou/Desktop/dynamic2.mov")!)
    )
}
