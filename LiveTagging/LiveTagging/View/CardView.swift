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
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .padding(.bottom, 10)
            Text(title)
                .font(.headline)
        }
        .frame(width: 150, height: 150)
        .background(Color.cyan.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
    }
}

#Preview {
    CardView(icon: "book.pages", title: "サンプル")
}
