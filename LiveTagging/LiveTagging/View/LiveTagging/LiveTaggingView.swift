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
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var cameraController = CameraController()
    @State private var videoItem = VideoItem(id: UUID(), videoTitle: NSLocalizedString("新規録画", comment: "新規録画"))
    @State var tagSetList: [CustomTagSet]
    @State var selectedTagSet: CustomTagSet
    @State private var showAlert = false
    
    init(tagSetList: [CustomTagSet]) {
        self._tagSetList = State(initialValue: tagSetList)
        self._selectedTagSet = State(initialValue: tagSetList.first ??
                                     CustomTagSet(id: UUID(),
                                                  tagSetName: "デフォルトタグセット",
                                                  tags: [CustomTagItem(id: UUID(), itemLabel: "パス"),
                                                         CustomTagItem(id: UUID(), itemLabel: "キャリー"),
                                                         CustomTagItem(id: UUID(), itemLabel: "キック"),
                                                         CustomTagItem(id: UUID(), itemLabel: "タックル")]))
    }
    
    var body: some View {
        ZStack {
            CameraStreamView(cameraController: cameraController)
            
            VStack {
                
                HStack {
                    Spacer()
                    if !tagSetList.isEmpty {
                        // タグセット選択用Picker
                        Picker("タグセット", selection: $selectedTagSet) {
                            ForEach(tagSetList, id: \.self) { tagSet in
                                Text(tagSet.tagSetName).tag(tagSet)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                        .padding()
                    }
                }
                
                Spacer()
                if cameraController.isRecording {
                    HStack {
                        // タイムライン
                        TimelineView(timeline: $videoItem.timeline)
                            .frame(maxHeight: 200)
                        Spacer()
                    }
                }
                // タグボタン
                TagButtonView(tagSet: selectedTagSet, timeline: $videoItem.timeline, timeStamp: cameraController.currentRecordingTime)
                
                // 録画開始/停止ボタン
                Button(action: {
                    if cameraController.isRecording {
                        // 録画終了
                        cameraController.stopRecording()
                        videoItem.timeline.sort { $0.timeStamp < $1.timeStamp }
                        saveVideoItem()
                    } else {
                        // 録画開始
                        cameraController.startRecording()
                    }
                }) {
                    Image(systemName: cameraController.isRecording ? "stop.circle" : "record.circle")
                        .font(.largeTitle)
                        .padding()
                        .foregroundColor(cameraController.isRecording ? Color.red : Color.white)
                }
            }
        }
        .onAppear {
            cameraController.startSession()
        }
        .onDisappear {
            if cameraController.isRecording {
                showAlert = true
            } else {
                cameraController.stopSession()
            }
        }
        .onChange(of: cameraController.recordedVideoURL) {
            if let newURL = cameraController.recordedVideoURL {
                videoItem.videoURL = newURL
                print("新しいビデオURL: \(newURL)")
            }
        }
        .onChange(of: cameraController.recordedLocalIdentifier) {
            if let newIdentifier = cameraController.recordedLocalIdentifier {
                videoItem.localIdentifier = newIdentifier
                print("新しいlocalIdentifier: \(newIdentifier)")
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("録画中です"),
                message: Text("録画を終了してから戻りますか？"),
                primaryButton: .destructive(Text("はい")) {
                    cameraController.stopRecording()
                    cameraController.stopSession()
                    dismiss()
                },
                secondaryButton: .cancel(Text("いいえ"))
            )
        }
    }
    
    // 録画終了時にVideoItemをSwiftDataに保存
    private func saveVideoItem() {
        do {
            modelContext.insert(videoItem)
            try modelContext.save()
            print("ビデオアイテムが保存されました")
        } catch {
            print("ビデオアイテムの保存に失敗しました: \(error.localizedDescription)")
        }
    }
}

//#Preview {
//    LiveTaggingView()
//}
