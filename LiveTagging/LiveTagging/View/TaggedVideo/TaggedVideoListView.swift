//
//  TaggedVideoListView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/12.
//

import SwiftUI

struct TaggedVideoListView: View {
    @Environment(\.modelContext) private var modelContext
    @State var videoList: [VideoItem]
    
    var body: some View {
        NavigationView {
            List {
                ForEach($videoList, id: \.id) { $videoItem in
                    NavigationLink(destination: TaggedVideoView(videoItem: $videoItem)) {
                        HStack {
                            Text(videoItem.videoTitle)
                            Text(videoItem.videoURL?.absoluteString ?? "URLなし")
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("ビデオリスト")
            .toolbar {
                EditButton()
            }
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let videoItem = videoList[index]
            modelContext.delete(videoItem)
        }
        videoList.remove(atOffsets: offsets)
    }
}


//#Preview {
//    TaggedVideoListView(videoList: <#[VideoItem]#>)
//}
