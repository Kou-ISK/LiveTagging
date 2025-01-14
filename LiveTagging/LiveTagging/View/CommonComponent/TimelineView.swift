//
//  TimelineView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/12.
//

import SwiftUI

struct TimelineView: View {
    @Binding var timeline: [TimelineItem]
    var body: some View {
        // タイムライン
        ScrollView(.vertical){
            VStack(alignment:.leading){
                ForEach(timeline, id:\.id){item in
                    HStack{
                        Text(formatTime(item.timeStamp))
                        Text(item.itemLabel)
                    }
                    .padding(4)
                    .foregroundColor(.white)
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
    TimelineView(timeline: .constant([
        TimelineItem(id: UUID(), timeStamp: 1.023, itemLabel: "タックル"),
        TimelineItem(id: UUID(), timeStamp: 1.023, itemLabel: "タックル")
    ])
    )
}
