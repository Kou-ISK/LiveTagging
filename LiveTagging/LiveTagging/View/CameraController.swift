//
//  CameraController.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/11.
//

import AVFoundation
import SwiftUI

// カメラキャプチャを管理するクラス
class CameraController: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate {
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var videoOutput: AVCaptureMovieFileOutput?
    private var movieOutputURL: URL?
    
    @Published var isRecording = false
    var previewLayer: AVCaptureVideoPreviewLayer? {
        return videoPreviewLayer
    }

    func startSession() {
        guard captureSession == nil else { return }

        // セッションの作成
        captureSession = AVCaptureSession()

        // デバイスの取得
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession?.canAddInput(videoDeviceInput) == true else { return }
        
        captureSession?.addInput(videoDeviceInput)

        // プレビュー用のレイヤー設定
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = .resizeAspectFill

        // ビデオ出力の設定
        videoOutput = AVCaptureMovieFileOutput()
        if let videoOutput = videoOutput, captureSession?.canAddOutput(videoOutput) == true {
            captureSession?.addOutput(videoOutput)
        }

        // セッションを開始
        captureSession?.startRunning()
    }

    func stopSession() {
        captureSession?.stopRunning()
        captureSession = nil
        videoPreviewLayer = nil
    }

    func startRecording() {
        guard !isRecording else { return }
        
        // 録画のURLを指定
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
        movieOutputURL = outputURL
        
        if let movieOutput = videoOutput {
            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
            isRecording = true
        }
    }

    func stopRecording() {
        guard isRecording else { return }
        
        if let movieOutput = videoOutput {
            movieOutput.stopRecording()
            isRecording = false
        }
    }

    // AVCaptureFileOutputRecordingDelegate メソッドの実装
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {
        if let error = error {
            print("録画エラー: \(error.localizedDescription)")
        } else {
            print("録画が完了しました。ファイルのURL: \(outputFileURL)")
        }
    }
}
