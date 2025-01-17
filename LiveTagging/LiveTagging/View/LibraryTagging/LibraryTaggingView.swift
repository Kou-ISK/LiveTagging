//
//  LibraryTaggingView.swift
//  LibraryTagging
//
//  Created by 井坂航 on 2025/01/15.
//

//import SwiftUI
//import AVFoundation
//import _AVKit_SwiftUI
//
//struct LibraryTaggingView: View {
//    @Environment(\.modelContext) private var modelContext
//    
//    @State private var videoItem = VideoItem(id: UUID(), videoTitle: "新規録画")
//    @State var tagSet: CustomTagSet
//    
//    @State var player: AVPlayer?
//    @State private var isPickerPresented = true
//    
//    var body: some View {
//        ZStack {
//            if let url = videoItem.videoURL {
//                VideoPlayer(player: player ?? AVPlayer(url: url))
//                    .edgesIgnoringSafeArea(.all)
//            } else {
//                Text("ビデオが選択されていません")
//                    .foregroundColor(.white)
//                    .font(.title)
//            }
//            
//            VStack {
//                Spacer()
//                HStack {
//                    // タイムライン
//                    TimelineView(timeline: $videoItem.timeline)
//                        .frame(maxHeight: 150)
//                    Spacer()
//                }
//                // タグボタン
//                // TODO: 再生時間を取得できるようにする
//                TagButtonView(tagSet: tagSet, timeline: $videoItem.timeline, timeStamp: player?.currentTime().seconds ?? 0)
//            }
//        }
//        .fullScreenCover(isPresented: $isPickerPresented) {
//            PhotoLibraryMoviePickerView(videoURL: $videoItem.videoURL)
//        }
//    }
//}

//#Preview {
//    LibraryTaggingView()
//}
