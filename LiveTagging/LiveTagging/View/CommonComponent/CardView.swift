//
//  CardView.swift
//  LiveTagging
//
//  Created by 井坂航 on 2025/01/16.
//

import SwiftUI

struct CardView: View {
    let icon: String
    let title: String
    let gradient: LinearGradient
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                .padding(.bottom, 10)
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(width: 150, height: 150)
        .background(gradient)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    VStack(spacing: 20) {
        CardView(
            icon: "record.circle",
            title: "録画",
            gradient: LinearGradient(
                colors: [Color.red, Color.purple],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        CardView(
            icon: "books.vertical.circle",
            title: "タグ付け済み映像",
            gradient: LinearGradient(
                colors: [Color.green, Color.blue],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        CardView(
            icon: "gear",
            title: "設定",
            gradient: LinearGradient(
                colors: [Color.gray, Color.blue],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        CardView(
            icon: "folder.fill",
            title: "ライブラリから",
            gradient: LinearGradient(
                colors: [Color.yellow, Color.orange],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    .padding()
}
