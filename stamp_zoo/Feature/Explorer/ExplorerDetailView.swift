//
//  ExplorerDetailView.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import SwiftUI

struct ExplorerDetailView: View {
    let facility: Facility
    let isVisited: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 헤더 이미지
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.green.opacity(0.6))
                        .frame(height: 300)
                        .overlay(
                            Image(systemName: "leaf.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.8))
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // 정보 영역
                VStack(alignment: .leading, spacing: 16) {
                    // 제목과 로고
                    HStack(alignment: .top, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(facility.name)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text(facility.location ?? "위치 정보 없음")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // 로고 이미지
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.green.opacity(0.8))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "pawprint.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                            )
                    }
                    
                    // 설명
                    Text(facility.detail)
                        .font(.body)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("")
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
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ExplorerDetailAnimalsView(
                    facility: facility
                )) {
                    HStack(spacing: 6) {
                        Text("동물을 보러")
                            .font(.system(size: 14, weight: .medium))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.green)
                    .cornerRadius(20)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ExplorerDetailView(
            facility: Facility(
                name: "쿠시로시립동물원",
                type: .zoo,
                location: "홋카이도, 쿠시로시",
                image: "deer_image",
                logoImage: "zoo_logo",
                mapImage: "zoo_map",
                mapLink: "https://example.com",
                detail: "다양한 동물들과 함께하는 즐거운 동물원입니다."
            ),
            isVisited: false
        )
    }
} 