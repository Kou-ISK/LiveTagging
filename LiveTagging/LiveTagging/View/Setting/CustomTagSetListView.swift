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
    @State private var isEditMode: Bool = false
    
    var body: some View {
        NavigationStack{
            List{
                ForEach($tagSetList, id:\.self.id){$tagSet in
                    // 編集モードの際のみ表示
                    if(isEditMode){
                        HStack{
                            // 削除ボタン
                            Button(action: {
                                deleteCustomTagSetListItem(item: tagSet)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 4)
                            }
                            Text(tagSet.tagSetName)
                        }
                    }else{
                        NavigationLink(destination: EditCustomTagSetView(tagSet: $tagSet), label: {
                            Text(tagSet.tagSetName)
                        })
                    }
                }
                if(!isEditMode){
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
        }.toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button(isEditMode ? "完了": "編集"){
                    isEditMode.toggle()
                }
            }
        }
    }
    
    private func deleteCustomTagSetListItem(item: CustomTagSet) {
        if let index = tagSetList.firstIndex(where: { $0.id == item.id }) {
            // モデルから削除
            modelContext.delete(tagSetList[index])
            // 配列から削除
            tagSetList.remove(at: index)
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
//    CustomTagSetListView(tagSetList: .constant(PreviewData().previewTagsetList))
//}
