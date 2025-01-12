//
//  CameraStreamView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/11.
//

import SwiftUI
import AVFoundation

struct CameraStreamView: View {
    @ObservedObject var cameraController: CameraController

    var body: some View {
        ZStack {
            // カメラのストリーミング映像を表示
            if let previewLayer = cameraController.previewLayer {
                CameraPreviewLayerView(previewLayer: previewLayer)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("カメラの準備中...")
                    .foregroundColor(.white)
                    .font(.title)
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

struct CameraPreviewLayerView: UIViewRepresentable {
    var previewLayer: AVCaptureVideoPreviewLayer

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.layer.addSublayer(previewLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            self.previewLayer.frame = uiView.bounds
        }
    }
}


#Preview {
    CameraStreamView(cameraController: CameraController())
}
