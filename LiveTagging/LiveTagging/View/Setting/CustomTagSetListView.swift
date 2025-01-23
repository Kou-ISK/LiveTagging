//
//  CustomTagSetListView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/16.
//

import SwiftUI

struct CustomTagSetListView: View {
    @Environment(\.modelContext)private var modelContext
    
    @Binding var tagSetList: [CustomTagSet]
    @State private var currentTagSetListName: String = ""
    
    var body: some View {
        NavigationStack{
            List{
                ForEach($tagSetList, id:\.self.id){$tagSet in
                    NavigationLink(destination: EditCustomTagSetView(tagSet: $tagSet), label: {
                    Text(tagSet.tagSetName)
                })
            }
                HStack{
                    Button(action: {
                        if(!currentTagSetListName.isEmpty){
                            let newTagSet = CustomTagSet(id: UUID(), tagSetName: currentTagSetListName, tags: [])
                            tagSetList.append(newTagSet)
                            modelContext.insert(newTagSet)
                            currentTagSetListName = ""
                            do{
                                try modelContext.save()
                            }catch{
                                print("エラーが発生しました: \(error.localizedDescription)")
                            }
                        }
                    }, label: {
                        Image(systemName: "plus.circle.fill").foregroundStyle(.blue)
                    }).padding(.horizontal, 4)
                    TextField("新規タグセット", text: $currentTagSetListName)
                }
            }
        }
    }
}

//#Preview {
//    CustomTagSetListView(tagSetList: .constant(previewTagsetList))
//}
