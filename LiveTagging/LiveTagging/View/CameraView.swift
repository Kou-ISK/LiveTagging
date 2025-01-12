//
//  LiveTaggingView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/11.
//

import SwiftUI
import AVFoundation

struct LiveTaggingView: View {
    @StateObject private var cameraController = CameraController()
    var body: some View {
        ZStack{
            CameraStreamView(cameraController: cameraController)
            
            // 録画開始/停止ボタン
            Button(action: {
                if cameraController.isRecording {
                    cameraController.stopRecording()
                } else {
                    cameraController.startRecording()
                }
            }) {
                Text(cameraController.isRecording ? "録画停止" : "録画開始")
                    .font(.largeTitle)
                    .padding()
                    .background(cameraController.isRecording ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
        }
        .onAppear {
            cameraController.startSession()
        }
        .onDisappear {
            cameraController.stopSession()
        }
    }
}

#Preview {
    LiveTaggingView()
}
