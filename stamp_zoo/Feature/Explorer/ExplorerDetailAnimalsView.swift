//
//  ExplorerDetailAnimalsView.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import SwiftUI
import SwiftData

struct ExplorerDetailAnimalsView: View {
    let facility: Facility
    
    @Environment(\.dismiss) private var dismiss
    @Query private var allAnimals: [Animal]
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    
    // 해당 시설의 동물들만 필터링
    private var animals: [Animal] {
        allAnimals.filter { $0.facility.id == facility.id }
    }
    
    var body: some View {
        mainContentView
            .navigationTitle(facility.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
            }
    }
    
    private var mainContentView: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    animalCardsStack(geometry: geometry)
                        .offset(x: dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    // 세로 스크롤이 아닌 경우에만 좌우 드래그 처리
                                    if abs(value.translation.width) > abs(value.translation.height) {
                                        dragOffset = value.translation.width
                                    }
                                }
                                .onEnded { value in
                                    let threshold: CGFloat = 50
                                    
                                    // 가로 방향 드래그가 더 큰 경우에만 카드 전환
                                    if abs(value.translation.width) > abs(value.translation.height) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            if value.translation.width > threshold && currentIndex > 0 {
                                                currentIndex -= 1
                                            } else if value.translation.width < -threshold && currentIndex < animals.count - 1 {
                                                currentIndex += 1
                                            }
                                            
                                            proxy.scrollTo(currentIndex, anchor: .center)
                                            dragOffset = 0
                                        }
                                    } else {
                                        // 세로 드래그인 경우 offset 리셋
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            dragOffset = 0
                                        }
                                    }
                                }
                        )
                }
                .scrollDisabled(true)
                .onAppear {
                    proxy.scrollTo(0, anchor: .center)
                }
            }
        }
        .ignoresSafeArea(.container, edges: []) // SafeArea를 모든 가장자리에서 존중
    }
    
    private func animalCardsStack(geometry: GeometryProxy) -> some View {
        HStack(spacing: 20) {
            ForEach(Array(animals.enumerated()), id: \.offset) { index, animal in
                animalCardView(animal: animal, index: index, geometry: geometry)
            }
        }
    }
    
    private func animalCardView(animal: Animal, index: Int, geometry: GeometryProxy) -> some View {
        AnimalDetailCard(
            animalName: animal.name,
            animalImage: animal.image,
            description: animal.detail
        )
        .frame(width: geometry.size.width)
        .id(index)
    }
    
    private var backButton: some View {
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

struct AnimalDetailCard: View {
    let animalName: String
    let animalImage: String
    let description: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                animalImageView
                animalInfoView
            }
            .background(Color("zooPopGreen").opacity(0.3))
            .cornerRadius(20)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100) // 탭바 공간 확보
        }
        .background(Color(.systemGray6))
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 1) // 상단 SafeArea 확실히 보호
        }
    }
    
    private var animalImageView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.7))
                .frame(height: 400)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 80))
                        .foregroundColor(.white.opacity(0.8))
                )
        }
        .padding(.horizontal, 20)
        .padding(.top, 40) // 네비게이션 바와의 겹침 방지를 위한 추가 패딩
    }
    
    private var animalInfoView: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(animalName)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(description)
                .font(.system(size: 14))
                .lineSpacing(6)
                .foregroundColor(.black.opacity(0.9))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
}

#Preview {
    NavigationView {
        ExplorerDetailAnimalsView(
            facility: Facility(
                name: "쿠시로시립동물원",
                type: .zoo,
                location: "홋카이도, 쿠시로시",
                image: "deer_image",
                logoImage: "zoo_logo",
                mapImage: "zoo_map",
                mapLink: "https://example.com",
                detail: "다양한 동물들과 함께하는 즐거운 동물원입니다."
            )
        )
    }
    .modelContainer(for: [Animal.self, Facility.self])
} 
