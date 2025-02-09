//
//  TaggedVideoListView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/12.
//

import SwiftUI
import AVFoundation
import Photos

struct TaggedVideoListView: View {
    @Environment(\.modelContext) private var modelContext
    @State var videoList: [VideoItem]
    @State var isEditMode = false
    
    var body: some View {
        NavigationView {
                List {
                    ForEach($videoList, id: \.id) { $videoItem in
                        if(isEditMode){
                            HStack {
                                TextField(videoItem.videoTitle, text: $videoItem.videoTitle).onSubmit {
                                    saveContext()
                                }.padding(4).border(.blue)
                                Spacer()
                                ThumbnailView(videoURL: videoItem.videoURL)
                            }
                        }else{
                            NavigationLink(destination: TaggedVideoView(videoItem: $videoItem)) {
                                HStack {
                                    Text(videoItem.videoTitle)
                                    Spacer()
                                    ThumbnailView(videoURL: videoItem.videoURL).padding(.trailing, 16)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            .navigationTitle("ビデオリスト")
        }.toolbar{
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(isEditMode ? "完了" : "編集"){
                    isEditMode.toggle()
                }
            })
        }
        .onAppear {
            updateVideoURLs()
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let videoItem = videoList[index]
            modelContext.delete(videoItem)
        }
        videoList.remove(atOffsets: offsets)
    }
    
    private func saveContext(){
        do{
            try modelContext.save()
            print("保存しました")
        }catch{
            print("ビデオタイトル更新に失敗しました: \(error.localizedDescription)")
        }
    }
    
    private func updateVideoURLs() {
        for index in videoList.indices {
            let videoItem = videoList[index]
            fetchVideoURLFromLocalIdentifier(videoItem.localIdentifier ?? "") { url in
                if let url = url {
                    videoList[index].videoURL = url
                }
            }
        }
    }
    
    private func fetchVideoURLFromLocalIdentifier(_ localIdentifier: String, completion: @escaping (URL?) -> Void) {
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
        guard let asset = assets.firstObject else {
            print("ビデオの取得に失敗しました: ローカル識別子が無効です")
            completion(nil)
            return
        }
        
        let options = PHVideoRequestOptions()
        options.version = .original
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (avAsset, audioMix, info) in
            if let urlAsset = avAsset as? AVURLAsset {
                let videoURL = urlAsset.url
                print("カメラロールのビデオURL: \(videoURL)")
                DispatchQueue.main.async {
                    completion(videoURL)
                }
            } else {
                print("ビデオURLの取得に失敗しました: AVAssetが無効です")
                completion(nil)
            }
        }
    }
}

#Preview {
        // プレビュー用のサンプルデータを作成
        let sampleVideoItem1 = VideoItem(id: UUID(), videoTitle: "サンプルビデオ1", videoURL: URL(filePath: "/Users/isakakou/Desktop/dynamic2.mov"))
        let sampleVideoItem2 = VideoItem(id: UUID(), videoTitle: "サンプルビデオ2", videoURL: URL(string: "https://www.example.com/sample2.mp4"))
     let view = TaggedVideoListView(videoList: [sampleVideoItem1, sampleVideoItem2])
}
