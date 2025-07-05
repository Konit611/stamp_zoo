//
//  ExplorerView.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import SwiftUI

struct ExplorerView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("🔍 탐험가")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
                
                Text("새로운 스탬프를 발견해보세요!")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationTitle("탐험")
        }
    }
}

#Preview {
    ExplorerView()
}

