//
//  SettingView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/16.
//

import SwiftUI

struct SettingView: View {
    @State var tagSetList: [CustomTagSet]
    var body: some View {
        NavigationStack{
            List{
                NavigationLink(destination: CustomTagSetListView(tagSetList: $tagSetList), label: {Text("カスタムタグセット管理")})
            }
        }
    }
}

#Preview {
    SettingView(tagSetList: previewTagsetList)
}
