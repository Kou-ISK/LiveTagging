//
//  CameraController.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/11.
//

import AVFoundation
import SwiftUI

class CameraController: ObservableObject {
    @Published var isRecording = false
    var session: AVCaptureSession?
    @Published var previewLayer: AVCaptureVideoPreviewLayer?

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
        // 録画開始の実装
        isRecording = true
    }

    func stopRecording() {
        // 録画停止の実装
        isRecording = false
    }
}
