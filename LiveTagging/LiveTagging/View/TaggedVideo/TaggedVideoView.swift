//
//  TaggedVideoView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/12.
//

import SwiftUI
import AVKit
import Photos

struct TaggedVideoView: View {
    @Binding var videoItem: VideoItem
    
    @State var player: AVPlayer
        
        init(videoItem: Binding<VideoItem>) {
            self._videoItem = videoItem
            self._player = State(initialValue: AVPlayer(url: videoItem.wrappedValue.videoURL ?? URL(string: "https://www.example.com/sample.mp4")!))
        }
    
    var body: some View {
        ZStack {
            VideoPlayer(player: player)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                HStack{
                    TaggedVideoTimelineView(timeline: $videoItem.timeline, player: player)
                        .frame(maxHeight: 150)
                    Spacer()
                }
            }
        }.onAppear{
            // ローカル識別子を使用してビデオを再取得
            fetchVideoURLFromLocalIdentifier(videoItem.localIdentifier ?? "") { url in
                if let url = url {
                    videoItem.videoURL = url
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

struct TaggedVideoView_Previews: PreviewProvider {
    static var previews: some View {
        // プレビュー用のサンプルデータを作成
        let sampleVideoItem = VideoItem(id: UUID(), videoTitle: "サンプルビデオ", videoURL: URL(filePath: "/Users/isakakou/Desktop/dynamic2.mov"))
        sampleVideoItem.timeline = [
            TimelineItem(id: UUID(), timeStamp: 1.023, itemLabel: "タックル"),
            TimelineItem(id: UUID(), timeStamp: 3.023, itemLabel: "タックル")
        ]
        return TaggedVideoView(videoItem: .constant(sampleVideoItem))
    }
}
