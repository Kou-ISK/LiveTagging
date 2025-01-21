//
//  PreviewTagSet.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/16.
//

import Foundation

var previewTagset: CustomTagSet = CustomTagSet(id: UUID(), tagSetName: "タグセット", tags:[CustomTagItem(id: UUID(), itemLabel: "タックル"), CustomTagItem(id: UUID(), itemLabel: "パス")])

var previewTagsetList: [CustomTagSet] = [
    CustomTagSet(id: UUID(), tagSetName: "タグセット1", tags:[CustomTagItem(id: UUID(), itemLabel: "タックル"), CustomTagItem(id: UUID(), itemLabel: "パス")]),
    CustomTagSet(id: UUID(), tagSetName: "タグセット2", tags:[CustomTagItem(id: UUID(), itemLabel: "タックル2"), CustomTagItem(id: UUID(), itemLabel: "パス2")])]
