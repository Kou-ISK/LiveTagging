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

    private func saveVideoToPhotosLibrary(from sourceURL: URL) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                print("写真ライブラリへのアクセスが許可されていません")
                return
            }

            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: sourceURL)
            }) { success, error in
                if let error = error {
                    print("ビデオの保存に失敗しました: \(error.localizedDescription)")
                } else {
                    print("ビデオが写真ライブラリに保存されました")
                }
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
