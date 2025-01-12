//
//  LiveTaggingView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/11.
//

import SwiftUI
import AVFoundation

struct LiveTaggingView: View {
    @Environment(\.modelContext)private var modelContext
    
    @StateObject private var cameraController = CameraController()
    @State private var videoItem = VideoItem(id: UUID(), videoTitle: "新規録画", videoURL: URL(string: "about:blank")!)
    @State var tagSet: CustomTagSet
    
    var body: some View {
        ZStack{
            CameraStreamView(cameraController: cameraController)
            
            VStack{
                Spacer()
                if cameraController.isRecording {
                    TimelineView(timeline: $videoItem.timeline).frame(maxHeight: 200)
                    // タグボタン
                    TagButtonView(tagSet: tagSet, timeline: $videoItem.timeline, timeStamp: cameraController.getCurrentRecordingTime().seconds)
                }
                // 録画開始/停止ボタン
                Button(action: {
                    if cameraController.isRecording {
                        // 録画終了
                        cameraController.stopRecording()
                        modelContext.insert(videoItem)
                    } else {
                        // 録画開始
                        cameraController.startRecording()
                    }
                }) {
                    Image(systemName: cameraController.isRecording ? "record.circle" : "stop.circle")
                        .font(.largeTitle)
                        .padding()
                        .background(cameraController.isRecording ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .onAppear {
            cameraController.startSession()
        }
        .onDisappear {
            cameraController.stopSession()
        }
        .onChange(of: cameraController.recordedVideoURL) { newURL in
            if let newURL = newURL {
                videoItem.videoURL = newURL
                print("新しいビデオURL: \(newURL)")
            }
        }
        .onChange(of: cameraController.recordedLocalIdentifier) { newIdentifier in
            if let newURL = newIdentifier {
                videoItem.localIdentifier = newIdentifier
                print("新しいlocalIdentifier: \(newIdentifier)")
            }
        }
    }
}

//#Preview {
//    LiveTaggingView()
//}
