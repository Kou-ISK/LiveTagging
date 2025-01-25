//
//  TaggedVideoTimelineView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/13.
//

import SwiftUI
import AVFoundation

struct TaggedVideoTimelineView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Binding var timeline: [TimelineItem]
    @Binding var isEditMode: Bool
    
    var player: AVPlayer
    
    var body: some View {
        ScrollView(.vertical){
            VStack(alignment:.leading){
                ForEach($timeline, id:\.id){$item in
                        HStack{
                            // 編集モードの際のみ表示
                            if(isEditMode){
                                // 削除ボタン
                                Button(action: {
                                    deleteTimelineItem(item: item)
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                        .padding(.leading, 10)
                                }
                            }
                            
                            Button(action:{
                                let targetTime = CMTime(seconds: item.timeStamp, preferredTimescale: 600)
                                player.seek(to: targetTime)
                            }, label: {
                                HStack{
                                    Text(formatTime(item.timeStamp))
                                }
                                .padding(.horizontal, 4)
                                .foregroundColor(.white)
                            })
                            
                            if(isEditMode){
                                // 編集モードの際は変更可能
                                TextField("", text: $item.itemLabel).onSubmit {
                                    saveContext()
                                }
                            }else{
                                Text(item.itemLabel)
                            }
                        }.foregroundStyle(.white)
                        .padding(4)
                    
                }
            }
        }.frame(maxWidth: 200, maxHeight: 150)
            .background(.gray.opacity(0.2))
            .padding(.vertical, 32)
    }
    
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func deleteTimelineItem(item: TimelineItem) {
        if let index = timeline.firstIndex(where: { $0.id == item.id }) {
            // モデルから削除
            modelContext.delete(timeline[index])
            // 配列から削除
            timeline.remove(at: index)
            isEditMode.toggle()
        }
    }
    
    private func saveContext(){
        do{
            try modelContext.save()
            print("保存しました")
        }catch{
            print("タイムライン更新に失敗しました: \(error.localizedDescription)")
        }
    }
}

#Preview {
    TaggedVideoTimelineView(timeline: .constant([
        TimelineItem(id: UUID(), timeStamp: 1.023, itemLabel: "タックル"),
        TimelineItem(id: UUID(), timeStamp: 1.023, itemLabel: "タックル")
    ]), isEditMode: .constant(true), player: AVPlayer(url: URL(filePath: "/Users/isakakou/Desktop/dynamic2.mov")!)
    )
    
    TaggedVideoTimelineView(timeline: .constant([
        TimelineItem(id: UUID(), timeStamp: 1.023, itemLabel: "タックル"),
        TimelineItem(id: UUID(), timeStamp: 1.023, itemLabel: "タックル")
    ]), isEditMode: .constant(false), player: AVPlayer(url: URL(filePath: "/Users/isakakou/Desktop/dynamic2.mov")!)
    )
}
