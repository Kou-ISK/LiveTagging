//
//  MockCameraStreamView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/24.
//

import SwiftUI

struct MockCameraStreamView: View {
    @ObservedObject var cameraController: MockCameraController
    @State private var lastScale: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            // 背景としてカメラ画像を表示
            Image("MockCameraImage")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()  // 画像をフィットさせる
                .frame(width: geometry.size.width, height: geometry.size.height) // 親ビューのサイズに合わせて調整
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
    MockCameraStreamView(cameraController: MockCameraController())
}
