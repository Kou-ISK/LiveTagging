//
//  TagButtonView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/12.
//

import SwiftUI

struct TagButtonView: View {
    @Environment(\.modelContext)private var modelContext
    
    var tagSet: CustomTagSet
    @Binding var timeline: [TimelineItem]
    var timeStamp: Double
    
    var body: some View {
        ScrollView(.horizontal){
            HStack{
                ForEach(tagSet.tags, id:\.id){tag in
                    Button(action: {
                        timeline.append(TimelineItem(id: UUID(), timeStamp: timeStamp, itemLabel: tag.itemLabel))
                        do {
                            try modelContext.save()
                        }catch{
                            print("保存エラー: \(error.localizedDescription)")
                        }
                    }, label: {
                        Text(tag.itemLabel)
                            .bold()
                            .padding(4)
                            .foregroundStyle(.white)
                            .background(.gray.opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    })
                }
            }
        }
    }
}

//#Preview {
//    TagButtonView(tagSet: CustomTagSet(id: UUID(), tagSetName: "タグセット", tags:[CustomTagItem(id: UUID(), itemLabel: "タックル"), CustomTagItem(id: UUID(), itemLabel: "パス")]))
//}
