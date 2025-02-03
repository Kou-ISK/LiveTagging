//
//  EditCustomTagSetView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/16.
//

import SwiftUI

struct EditCustomTagSetView: View {
    @Environment(\.modelContext)private var modelContext
    
    @Binding var tagSet: CustomTagSet
    @State private var currentTagItemLabel: String = ""
    @State private var isEditMode: Bool = true
    
    var body: some View {
        NavigationStack{
        Text(tagSet.tagSetName)
            List{
                ForEach(tagSet.tags, id:\.self.id){tagItem in
                    HStack{
                        // 編集モードの際のみ表示
                        if(isEditMode){
                            // 削除ボタン
                            Button(action: {
                                deleteCustomTagItem(item: tagItem)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 4)
                            }
                        }
                        Text(tagItem.itemLabel)
                    }
                }
                HStack{
                    Button(action: {
                        if(!currentTagItemLabel.isEmpty){
                            let newTagItem = CustomTagItem(id: UUID(), itemLabel: currentTagItemLabel)
                            tagSet.tags.append(newTagItem)
                            modelContext.insert(newTagItem)
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
        }.toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button(isEditMode ? "完了": "編集"){
                    isEditMode.toggle()
                }
            }
        }
    }
    
    private func deleteCustomTagItem(item: CustomTagItem) {
        if let index = tagSet.tags.firstIndex(where: { $0.id == item.id }) {
            // モデルから削除
            modelContext.delete(tagSet.tags[index])
            // 配列から削除
            tagSet.tags.remove(at: index)
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

//#Preview {
//    EditCustomTagSetView(tagSet: .constant(PreviewData().previewTagset))
//}
