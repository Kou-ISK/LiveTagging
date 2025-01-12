//
//  CameraController.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/11.
//

import AVFoundation
import SwiftUI
import Photos

class CameraController: NSObject, ObservableObject {
    @Published var isRecording = false
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    @Published var recordedVideoURL: URL?
    @Published var recordedLocalIdentifier: String? // ローカル識別子を保持
    var session: AVCaptureSession?
    var movieOutput: AVCaptureMovieFileOutput?
    
    func startSession() {
        session = AVCaptureSession()
        session?.sessionPreset = .high
        
        guard let session = session else {
            print("セッションの初期化に失敗しました")
            return
        }
        
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), session.canAddInput(videoDeviceInput) else {
            print("カメラデバイスの入力を追加できません")
            return
        }
        session.addInput(videoDeviceInput)
        
        movieOutput = AVCaptureMovieFileOutput()
        if session.canAddOutput(movieOutput!) {
            session.addOutput(movieOutput!)
        } else {
            print("ムービー出力を追加できません")
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = .resizeAspectFill
        
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
            DispatchQueue.main.async {
                if session.isRunning {
                    print("セッションが正常に開始されました")
                    print("プレビューのレイヤーが設定されました: \(String(describing: self.previewLayer))")
                } else {
                    print("セッションの開始に失敗しました")
                }
            }
        }
    }
    
    func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.session?.stopRunning()
            DispatchQueue.main.async {
                self.session = nil
                self.previewLayer = nil
            }
        }
    }
    
    func startRecording() {
        guard let movieOutput = movieOutput else {
            print("ムービー出力が設定されていません")
            return
        }
        let timestamp = Int(Date().timeIntervalSince1970)
        let outputPath = NSTemporaryDirectory() + "output_\(timestamp).mov"
        let outputURL = URL(fileURLWithPath: outputPath)
        print("録画開始: \(outputURL)")
        movieOutput.startRecording(to: outputURL, recordingDelegate: self)
        isRecording = true
    }
    
    func stopRecording() {
        guard let movieOutput = movieOutput else {
            print("ムービー出力が設定されていません")
            return
        }
        movieOutput.stopRecording()
        isRecording = false
    }
    
    func getCurrentRecordingTime() -> CMTime {
        return movieOutput?.recordedDuration ?? CMTime.zero
    }
    
    private func saveVideoToPhotosLibrary(from sourceURL: URL) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                print("写真ライブラリへのアクセスが許可されていません")
                return
            }
            
            var localIdentifier: String?
            
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: sourceURL)
                localIdentifier = request?.placeholderForCreatedAsset?.localIdentifier
            }) { success, error in
                if let error = error {
                    print("ビデオの保存に失敗しました: \(error.localizedDescription)")
                } else {
                    print("ビデオが写真ライブラリに保存されました")
                    if let localIdentifier = localIdentifier {
                        self.recordedLocalIdentifier = localIdentifier
                        self.fetchVideoURLFromLocalIdentifier(localIdentifier)
                        print("ローカル識別子が登録されました: \(localIdentifier)")
                    }
                }
            }
        }
    }
    
    private func fetchVideoURLFromLocalIdentifier(_ localIdentifier: String) {
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
        guard let asset = assets.firstObject else {
            print("ビデオの取得に失敗しました")
            return
        }
        
        let options = PHVideoRequestOptions()
        options.version = .original
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (avAsset, audioMix, info) in
            if let urlAsset = avAsset as? AVURLAsset {
                let videoURL = urlAsset.url
                print("カメラロールのビデオURL: \(videoURL)")
                DispatchQueue.main.async {
                    self.recordedVideoURL = videoURL
                }
            } else {
                print("ビデオURLの取得に失敗しました")
            }
        }
    }
}

extension CameraController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("録画に失敗しました: \(error.localizedDescription)")
        } else {
            print("録画が完了しました: \(outputFileURL)")
            saveVideoToPhotosLibrary(from: outputFileURL)
        }
    }
}
