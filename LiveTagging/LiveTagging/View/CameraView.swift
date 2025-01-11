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
        CameraRecordingView(cameraController: cameraController)
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
