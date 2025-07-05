//
//  BingoDetailView.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import SwiftUI

struct BingoDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("🎯 빙고 상세")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
            
            Text("빙고 상세 정보가 여기에 표시됩니다.")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .background(Color(.systemGray6))
        .navigationTitle(NSLocalizedString("bingo_detail", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.black)
                        .clipShape(Circle())
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        BingoDetailView()
    }
} 