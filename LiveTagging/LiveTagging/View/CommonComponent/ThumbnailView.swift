//
//  ThumbnailView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/22.
//

import SwiftUI
import AVFoundation

struct ThumbnailView: View {
    var videoURL: URL?
    
    var body: some View {
        if let thumbnailImage = generateThumbnail(for: videoURL) {
            Image(uiImage: thumbnailImage)
                .resizable()
                .frame(width: 100, height: 100)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(8)
        } else {
            Text("サムネイルなし")
                .frame(width: 100, height: 100)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(8)
        }
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
}

#Preview {
    ThumbnailView(videoURL: URL(filePath: "/Users/isakakou/Desktop/dynamic2.mov"))
}
