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
    @Query private var CustomTagSet: [CustomTagSet]
    @Query private var VideoItem: [VideoItem]

    var body: some View {
        NavigationStack{
            // ライブラリから
            NavigationLink(destination: EmptyView(), label: {Image(systemName: "folder.fill")})
            // 新規レコード
            NavigationLink(destination: LiveTaggingView(), label: {Image(systemName:"record.circle")})
            // 閲覧
            NavigationLink(destination: EmptyView(), label: {Image(systemName: "books.vertical.circle")})
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: VideoItem.self, inMemory: true)
}
