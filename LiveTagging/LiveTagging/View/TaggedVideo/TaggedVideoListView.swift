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
    
    var body: some View {
        NavigationView {
            List {
                ForEach($videoList, id: \.id) { $videoItem in
                    NavigationLink(destination: TaggedVideoView(videoItem: $videoItem)) {
                        HStack {
                            Text(videoItem.videoTitle)
                            if let thumbnailImage = generateThumbnail(for: videoItem.videoURL) {
                                Image(uiImage: thumbnailImage)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(8)
                            } else {
                                Text("サムネイルなし")
                                    .frame(width: 100, height: 100)
                                    .background(Color.gray)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("ビデオリスト")
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
    
    private func generateThumbnail(for url: URL?) -> UIImage? {
        guard let url = url else { return nil }
        
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        let time = CMTime(seconds: 1, preferredTimescale: 600)
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("サムネイル生成に失敗しました: \(error.localizedDescription)")
            return nil
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

struct TaggedVideoListView_Previews: PreviewProvider {
    static var previews: some View {
        // プレビュー用のサンプルデータを作成
        let sampleVideoItem1 = VideoItem(id: UUID(), videoTitle: "サンプルビデオ1", videoURL: URL(string: "https://www.example.com/sample1.mp4"))
        let sampleVideoItem2 = VideoItem(id: UUID(), videoTitle: "サンプルビデオ2", videoURL: URL(string: "https://www.example.com/sample2.mp4"))
        return TaggedVideoListView(videoList: [sampleVideoItem1, sampleVideoItem2])
    }
}
