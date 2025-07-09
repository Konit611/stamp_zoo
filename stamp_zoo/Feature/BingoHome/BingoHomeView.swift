//
//  BingoHomeView.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import SwiftUI
import SwiftData

struct BingoHomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = BingoHomeViewModel()
    @State private var presentedDestination: NavigationDestination?
    
    enum NavigationDestination {
        case settings
        case bingoDetail
        case bingoQR
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 상단 헤더
                headerView()
                
                // 메인 컨텐츠
                VStack(spacing: 20) {
                    // 제목
                    titleView()
                    
                    // 스탬프 그리드
                    stampGridView()
                    
                    // QR 버튼
                    qrButton()
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 30)
            }
            .background(Color(.systemGray6))
            .ignoresSafeArea(.all, edges: .top)
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .settings:
                    SettingsView()
                        .navigationBarTitleDisplayMode(.inline)
                case .bingoDetail:
                    BingoDetailView()
                        .navigationBarTitleDisplayMode(.inline)
                case .bingoQR:
                    BingoQRView()
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .onAppear {
                // viewModel에 modelContext 설정
                viewModel.updateModelContext(modelContext)
            }
        }
    }
    
    // MARK: - Header View
    private func headerView() -> some View {
        HStack {
            // 보라색 원
            Circle()
                .fill(Color.purple)
                .frame(width: 40, height: 40)
            
            Spacer()
            
            // 설정 아이콘
            NavigationLink(value: NavigationDestination.settings) {
                Image(systemName: "gearshape")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 30)
        .padding(.top, 60)
        .padding(.bottom, 20)
    }
    
    // MARK: - Title View
    private func titleView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(NSLocalizedString("stamp_rally_title", comment: ""))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            // 화살표 아이콘
            NavigationLink(value: NavigationDestination.bingoDetail) {
                Image(systemName: "arrow.right")
                    .font(.system(size: 21, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.black)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 10)
    }
    
    // MARK: - Stamp Grid View
    private func stampGridView() -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
            ForEach(0..<9, id: \.self) { index in
                stampCell(for: index)
            }
        }
        .padding(.horizontal, 10)
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
    
    // MARK: - QR Button
    private func qrButton() -> some View {
        NavigationLink(value: NavigationDestination.bingoQR) {
            Text(NSLocalizedString("get_stamp_with_qr", comment: ""))
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.green.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 25))
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    BingoHomeView()
}

