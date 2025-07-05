//
//  FieldGuideView.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import SwiftUI

struct FieldGuideView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("📚 필드 가이드")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
                
                Text("스탬프 컬렉션 가이드를 확인하세요!")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationTitle("가이드")
        }
    }
}

#Preview {
    FieldGuideView()
}

