//
//  CameraRecordingView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/11.
//

import SwiftUI

struct CameraRecordingView: View {
    @ObservedObject var cameraController: CameraController

    var body: some View {
        VStack {
            Spacer()
            
            HStack {
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
            .padding()
        }
    }
}


#Preview {
    CameraRecordingView(cameraController: CameraController())
}
