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
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    ForEach(timeline, id: \.id) { item in
                        HStack {
                            Text(formatTime(item.timeStamp))
                            Text(item.itemLabel)
                        }
                        .padding(4)
                        .foregroundColor(.white)
                        .id(item.id) // 各アイテムにIDを設定
                    }
                }
            }
            
            .background(.gray.gradient.opacity(0.2))
            .onChange(of: timeline) {
                // タイムラインが更新された際に一番下までスクロール
                if let lastItem = timeline.last {
                    withAnimation {
                        proxy.scrollTo(lastItem.id, anchor: .bottom)
                    }
                }
            }
        }.frame(maxWidth: 200, maxHeight: 150)
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
