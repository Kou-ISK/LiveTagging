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
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Live Tagging")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                
                Grid {
                    GridRow {
                        // TODO: いつか実装する
                        //                        NavigationLink(destination: LibraryTaggingView(tagSet: testTagset)) {
                        //                            CardView(icon: "folder.fill", title: "ライブラリから")
                        //                        }
                        NavigationLink(destination: LiveTaggingView(tagSetList: tagSetList)) {
                            CardView(
                                icon: "record.circle",
                                title: "録画",
                                gradient: LinearGradient(
                                    colors: [Color.red, Color.purple],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            
                        }
                        NavigationLink(destination: TaggedVideoListView(videoList: videoList)) {
                            CardView(
                                icon: "books.vertical.circle",
                                title: "タグ付け済み映像",
                                gradient: LinearGradient(
                                    colors: [Color.green, Color.blue],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        }
                    }
                    GridRow {
                        NavigationLink(destination: SettingView(tagSetList: tagSetList)) {
                            CardView(
                                icon: "gear",
                                title: "設定",
                                gradient: LinearGradient(
                                    colors: [Color.blue, Color.gray],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: VideoItem.self, inMemory: true)
}
