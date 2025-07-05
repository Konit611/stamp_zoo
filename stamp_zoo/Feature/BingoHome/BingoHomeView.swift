//
//  BingoHomeView.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import SwiftUI

struct BingoHomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("🎯 빙고 홈")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
                
                Text("스탬프 빙고 게임을 즐겨보세요!")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationTitle("홈")
        }
    }
}

#Preview {
    BingoHomeView()
}

