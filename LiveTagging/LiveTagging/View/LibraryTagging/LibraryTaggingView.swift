//
//  LibraryTaggingView.swift
//  LibraryTagging
//
//  Created by 井坂航 on 2025/01/15.
//

import SwiftUI
import AVFoundation
import _AVKit_SwiftUI
import Photos

struct LibraryTaggingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var videoItem = VideoItem(id: UUID(), videoTitle: NSLocalizedString("新規タグ付け", comment: "新規タグ付け"))
    @State var tagSetList: [CustomTagSet]
    @State var selectedTagSet: CustomTagSet
    @State var player: AVPlayer?
    @State private var isPickerPresented = true
    
    init(tagSetList: [CustomTagSet]) {
        self._tagSetList = State(initialValue: tagSetList)
        self._selectedTagSet = State(initialValue: tagSetList.first ??
                                     CustomTagSet(id: UUID(),
                                                  tagSetName: "デフォルトタグセット",
                                                  tags: [CustomTagItem(id: UUID(), itemLabel: "パス"),
                                                         CustomTagItem(id: UUID(), itemLabel: "キャリー"),
                                                         CustomTagItem(id: UUID(), itemLabel: "キック"),
                                                         CustomTagItem(id: UUID(), itemLabel: "タックル")]))
    }
    
    var body: some View {
        ZStack {
            if let url = videoItem.videoURL {
                VideoPlayer(player: player ?? AVPlayer(url: url))
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        print("VideoPlayer表示")
                        if player == nil {
                            player = AVPlayer(url: url)
                            // 再生準備ができたことを確認
                            player?.currentItem?.asset.loadValuesAsynchronously(forKeys: ["playable"]) {
                                DispatchQueue.main.async {
                                    print("ビデオ再生準備完了")
                                    player?.play()
                                }
                            }
                        }
                    }
            } else {
                Text("ビデオが選択されていません")
                    .foregroundColor(.white)
                    .font(.title)
            }
            
            VStack {
                HStack {
                    Spacer()
                    if !tagSetList.isEmpty {
                        // タグセット選択用Picker
                        Picker("タグセット", selection: $selectedTagSet) {
                            ForEach(tagSetList, id: \.self) { tagSet in
                                Text(tagSet.tagSetName).tag(tagSet)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                        .padding()
                    }
                }
                
                Spacer()
                
                HStack {
                    // タイムライン
                    TimelineView(timeline: $videoItem.timeline)
                    Spacer()
                }
                
                // タグボタン
                TagButtonView(tagSet: selectedTagSet,
                              timeline: $videoItem.timeline,
                              timeStamp: player?.currentTime().seconds ?? 0)
            }
        }
        .fullScreenCover(isPresented: $isPickerPresented) {
            PhotoLibraryMoviePickerView(videoURL: $videoItem.videoURL) { localIdentifier in
                print("localIdentifier設定: \(localIdentifier)")
                videoItem.localIdentifier = localIdentifier
            }
        }
        .onDisappear {
            saveVideoItem()
        }
    }
    
    private func saveVideoItem() {
        guard videoItem.videoURL != nil else { return }
        
        do {
            modelContext.insert(videoItem)
            try modelContext.save()
            print("ビデオアイテムが保存されました")
        } catch {
            print("ビデオアイテムの保存に失敗しました: \(error.localizedDescription)")
        }
    }
}

//#Preview {
//    LibraryTaggingView(tagSetList: PreviewData().previewTagsetList)
//}
