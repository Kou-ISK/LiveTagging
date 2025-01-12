//
//  ContentView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/11.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tagSetList: [CustomTagSet]
    @Query private var videoList: [VideoItem]
    
    // CustomTagSet のインスタンスを作成
    let testTagset = CustomTagSet(id: UUID(), tagSetName: "タグセット", tags:[CustomTagItem(id: UUID(), itemLabel: "タックル"), CustomTagItem(id: UUID(), itemLabel: "パス")])
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                // ライブラリから
                NavigationLink(destination: EmptyView(), label: {
                    HStack{
                        Image(systemName: "folder.fill")
                        Text("ライブラリから")
                    }
                    .padding(4)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                })
                // 新規レコード
                NavigationLink(destination: LiveTaggingView(tagSet: testTagset), label: {
                    HStack{
                        Image(systemName:"record.circle")
                        Text("録画")
                    }
                    .padding(4)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                })
                // 閲覧
                NavigationLink(destination: TaggedVideoListView(videoList: videoList), label: {
                    HStack{
                        Image(systemName: "books.vertical.circle")
                        Text("タグ付け済み映像の閲覧")
                    }
                    .padding(4)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                })
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: VideoItem.self, inMemory: true)
}
