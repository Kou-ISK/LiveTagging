//
//  EditCustomTagSetView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/16.
//

import SwiftUI

struct EditCustomTagSetView: View {
    @Environment(\.modelContext)private var modelContext
    
    @State var tagSet: CustomTagSet
    @State private var currentTagItemLabel: String = ""
    
    var body: some View {
        Text(tagSet.tagSetName)
        List{
            ForEach(tagSet.tags, id:\.self.id){tagItem in
                Text(tagItem.itemLabel)
            }
            HStack{
                Button(action: {
                    if(!currentTagItemLabel.isEmpty){
                        tagSet.tags.append(CustomTagItem(id: UUID(), itemLabel: currentTagItemLabel))
                        currentTagItemLabel = ""
                        do{
                            try modelContext.save()
                        }catch{
                            print("エラーが発生しました: \(error.localizedDescription)")
                        }
                    }
                }, label: {
                    Image(systemName: "plus.circle.fill").foregroundStyle(.blue)
                }).padding(.horizontal, 4)
                TextField("新規タグ", text: $currentTagItemLabel)
            }
        }
    }
}

#Preview {
    EditCustomTagSetView(tagSet: PreviewData().previewTagset)
}
