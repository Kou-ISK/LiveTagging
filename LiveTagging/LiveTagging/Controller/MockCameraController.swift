//
//  MockCameraController.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/24.
//

import Foundation
import SwiftUI
import Combine

class MockCameraController: ObservableObject {
    @Published var isRecording = false
    @Published var previewLayer: CALayer? // プレビュー用のダミーLayer
    @Published var recordedVideoURL: URL?
    @Published var recordedLocalIdentifier: String? // ローカル識別子を保持
    @Published var currentRecordingTime: Double = 0.0 // ダミー録画時間
    
    private var timer: Timer?
    private var recordingStartTime: Date?
    
    func startSession() {
        // ダミーのプレビューLayerを設定
        let layer = CALayer()
        layer.backgroundColor = UIColor.darkGray.cgColor
        previewLayer = layer
        print("モック: セッション開始")
    }
    
    func stopSession() {
        previewLayer = nil
        print("モック: セッション終了")
    }
    
    func startRecording() {
        isRecording = true
        recordingStartTime = Date()
        startTimer()
        print("モック: 録画開始")
    }
    
    func stopRecording() {
        isRecording = false
        stopTimer()
        if let startTime = recordingStartTime {
            let duration = Date().timeIntervalSince(startTime)
            currentRecordingTime = duration
            print("モック: 録画終了 (時間: \(duration)秒)")
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let startTime = self.recordingStartTime {
                self.currentRecordingTime = Date().timeIntervalSince(startTime)
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
