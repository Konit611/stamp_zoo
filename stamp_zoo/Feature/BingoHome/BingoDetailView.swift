//
//  BingoDetailView.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import SwiftUI
import SwiftData

struct BingoDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = BingoHomeViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // 빙고 보드 섹션
                VStack(spacing: 20) {
                    // 3x3 그리드 빙고 보드 (BingoHomeView와 동일)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                        ForEach(0..<9, id: \.self) { index in
                            stampCell(for: index)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                }
                .padding(.bottom, 20)
                
                // 스탬프 랠리 정보 섹션
                VStack(alignment: .leading, spacing: 16) {
                    // 제목
                    Text("ワクワク\nスタンプラリー")
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                    
                    // 설명 텍스트
                    Text("이 스탬프 랠리는 이러한 의미가 있어, 굉장히 재미있어! 이 스탬프 랠리는 이러한 의미가 있어, 굉장히 재미있어! 이 스탬프 랠리는 이러한 의미가 있어, 굉장히 재미있어! 이 스탬프 랠리는 이러한 의미가 있어, 굉장히 재미있어!\n\n이 스탬프 랠리는 이러한 의미가 있어, 굉장히 재미있어! 이 스탬프 랠리는 이러한 의미가 있어, 굉장히 재미있어! 이 스탬프 랠리는 이러한 의미가 있어, 굉장히 재미있어!\n\n이 스탬프 랠리는 이러한 의미가 있어, 굉장히 재미있어! 이 스탬프 랠리는 이러한 의미가 있어, 굉장히 재미있어!")
                        .font(.system(size: 16))
                        .lineSpacing(4)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
            }
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
        .onAppear {
            // viewModel에 modelContext 설정
            viewModel.updateModelContext(modelContext)
        }
    }
    
    // MARK: - Stamp Cell
    private func stampCell(for index: Int) -> some View {
        let stamp = viewModel.getStamp(at: index)
        
        return ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("zooBackgroundBlack"))
                .frame(height: 100)
            
            if let stamp = stamp, stamp.isCollected, let animal = stamp.animal {
                // 수집된 스탬프 표시
                VStack {
                    // 스탬프 이미지 (실패 시 기본 이미지)
                    Group {
                        if let image = UIImage(named: animal.stampImage) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else {
                            // 이미지 로드 실패 시 기본 이미지
                            Image("default_image")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Text(animal.name)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
                .padding(8)
                .background(Color.white.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            // 빈 스탬프 슬롯은 배경색만 표시 (아무 내용 없음)
        }
    }
}

#Preview {
    NavigationView {
        BingoDetailView()
    }
} 