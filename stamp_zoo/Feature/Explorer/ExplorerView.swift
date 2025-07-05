//
//  ExplorerView.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import SwiftUI

struct ExplorerView: View {
    @State private var selectedCategory: Category = .all
    
    enum Category: String, CaseIterable {
        case all = "전체"
        case zoo = "동물원"
        case aquarium = "수족관"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 제목
                VStack(alignment: .leading, spacing: 8) {
                    Text("참가하고 있는")
                        .font(.title2)
                        .fontWeight(.medium)
                    Text("동물원・수족관")
                        .font(.title2)
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // 카테고리 탭
                HStack(spacing: 8) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            Text(category.rawValue)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(selectedCategory == category ? .white : .primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    selectedCategory == category ? 
                                    Color.green.opacity(0.8) : Color.clear
                                )
                                .cornerRadius(20)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // 스크롤 뷰
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10)
                    ], spacing: 10) {
                        ForEach(0..<6) { index in
                            NavigationLink(destination: ExplorerDetailView(
                                title: "쿠시로시립동물원",
                                subtitle: "홋카이도, 쿠시로시",
                                imageName: "deer_image",
                                isVisited: index % 2 == 0
                            )) {
                                ZooCard(
                                    imageName: "deer_image",
                                    title: "쿠시로시립동물원",
                                    subtitle: "홋카이도, 쿠시로시",
                                    isVisited: index % 2 == 0
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

struct ZooCard: View {
    let imageName: String
    let title: String
    let subtitle: String
    let isVisited: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // 이미지 영역
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.6))
                    .frame(height: 140)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.8))
                    )
            }
            .padding(.top, 12)
            .padding(.horizontal, 12)
            
            // 정보 영역
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(subtitle)
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
                
                HStack {
                    Spacer()
                    Circle()
                        .fill(isVisited ? Color.green : Color.blue)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: isVisited ? "checkmark" : "arrow.right")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.top, 12)
            .padding(.bottom, 12)
        }
        .background(Color(.systemGray6).opacity(0.2))
        .background(Color.black.opacity(0.8))
        .cornerRadius(16)
    }
}

#Preview {
    ExplorerView()
}

