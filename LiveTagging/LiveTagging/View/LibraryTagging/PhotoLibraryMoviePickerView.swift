//
//  PhotoLibraryMoviePickerView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/15.
//

import SwiftUI
import PhotosUI
import Photos
import UniformTypeIdentifiers

struct PhotoLibraryMoviePickerView: UIViewControllerRepresentable {

    @Environment(\.dismiss) private var dismiss
    @Binding var videoURL: URL?
    var onSelectAsset: ((String) -> Void)? // localIdentifierを親ビューに渡すためのコールバック

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .videos
        configuration.preferredAssetRepresentationMode = .current
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {

        let parent: PhotoLibraryMoviePickerView

        init(_ parent: PhotoLibraryMoviePickerView) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            print("写真選択完了: 結果数 \(results.count)")
            
            guard let result = results.first,
                  let assetId = result.assetIdentifier else {
                parent.dismiss()
                return
            }
            
            print("選択されたアセット: identifier=\(assetId)")
            
            // PHAssetを取得
            let assets = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
            guard let asset = assets.firstObject else {
                print("PHAsset取得失敗")
                parent.dismiss()
                return
            }
            
            print("PHAsset取得成功: duration=\(asset.duration)")
            
            // AVAssetを取得
            let options = PHVideoRequestOptions()
            options.version = .current
            options.deliveryMode = .highQualityFormat
            options.isNetworkAccessAllowed = true
            
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { [weak self] (avAsset, _, _) in
                guard let self = self,
                      let urlAsset = avAsset as? AVURLAsset else {
                    print("AVAsset取得失敗")
                    return
                }
                
                print("URL取得成功: \(urlAsset.url)")
                
                DispatchQueue.main.async {
                    self.parent.videoURL = urlAsset.url
                    self.parent.onSelectAsset?(assetId)
                    self.parent.dismiss()
                }
            }
        }
    }
}
