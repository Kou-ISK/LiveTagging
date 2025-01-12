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
            ForEach(timeline, id:\.id){item in
                HStack{
                    Text(item.timeStamp.description)
                    Text(item.itemLabel)
                }.padding()
                    .foregroundColor(.white)
            }
        }.background(.gray.opacity(0.6)).padding(16)
    }
}

#Preview {
    TimelineView(timeline: .constant([
        TimelineItem(id: UUID(), timeStamp: 1.023, itemLabel: "タックル"),
        TimelineItem(id: UUID(), timeStamp: 1.023, itemLabel: "タックル")
    ])
    )
}
