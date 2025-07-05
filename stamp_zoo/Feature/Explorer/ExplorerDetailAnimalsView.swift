//
//  ExplorerDetailAnimalsView.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import SwiftUI
import SwiftData

struct ExplorerDetailAnimalsView: View {
    let zooTitle: String
    let zooSubtitle: String
    
    @Environment(\.dismiss) private var dismiss
    @Query private var animals: [Animal]
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        mainContentView
            .navigationTitle(zooTitle)
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
                                    dragOffset = value.translation.width
                                }
                                .onEnded { value in
                                    let threshold: CGFloat = 50
                                    
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        if value.translation.width > threshold && currentIndex > 0 {
                                            currentIndex -= 1
                                        } else if value.translation.width < -threshold && currentIndex < animals.count - 1 {
                                            currentIndex += 1
                                        }
                                        
                                        proxy.scrollTo(currentIndex, anchor: .center)
                                        dragOffset = 0
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
    }
    
    private func animalCardsStack(geometry: GeometryProxy) -> some View {
        HStack(spacing: 20) {
            ForEach(Array(animals.enumerated()), id: \.offset) { index, animal in
                animalCardView(animal: animal, index: index, geometry: geometry)
            }
        }
    }
    
    private func animalCardView(animal: Animal, index: Int, geometry: GeometryProxy) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            AnimalDetailCard(
                animalName: animal.name,
                animalSubName: getAnimalSubName(animal.name),
                animalImage: animal.image,
                description: getShortDescription(for: animal.name)
            )
            .padding(.top, 20)
        }
        .frame(width: geometry.size.width - 60)
        .padding(.leading, index == 0 ? 20 : 0)
        .padding(.trailing, index == animals.count - 1 ? 20 : 0)
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
    
    private func getAnimalSubName(_ name: String) -> String {
        switch name {
        case "늑대": return "おおかみ"
        case "얼룩말": return "しまうま"
        case "하마": return "かば"
        case "치타": return "ちーたー"
        case "북극곰": return "ほっきょくぐま"
        case "바다사자": return "あしか"
        default: return name.lowercased()
        }
    }
    
    private func getShortDescription(for animalName: String) -> String {
        switch animalName {
        case "늑대":
            return "늑대는 개과에 속하는 육식 포유동물로, 현재 개의 조상으로 여겨집니다. 뛰어난 사회성을 가진 동물로, 무리(팩)를 이루어 생활합니다. 사냥할 때는 뛰어난 팀워크를 발휘하며, 생태계에서 최상위 포식자로서 중요한 역할을 합니다."
        case "얼룩말":
            return "얼룩말은 아프리카 대륙에 서식하는 말과 동물로, 검은색과 흰색의 독특한 줄무늬 패턴으로 유명합니다. 줄무늬는 해충을 쫓고 포식자로부터 보호하는 역할을 합니다."
        case "하마":
            return "하마는 아프리카 대륙의 강과 호수에 서식하는 대형 포유동물입니다. 반수생 동물로 낮 시간의 대부분을 물 속에서 보내며, 영역 의식이 매우 강한 동물입니다."
        case "치타":
            return "치타는 지구상에서 가장 빠른 육상 동물로, 최고 시속 120km의 속도로 달릴 수 있습니다. 속도에 최적화된 몸을 가지고 있으며, 현재 멸종 위기에 처해 있습니다."
        case "북극곰":
            return "북극곰은 북극권에 서식하는 현존 최대의 육상 육식동물입니다. 극한의 추위에 적응된 독특한 신체 특징을 가지고 있으며, 기후변화로 인해 위기에 직면해 있습니다."
        case "바다사자":
            return "바다사자는 해양 포유동물로 뛰어난 수영 능력을 가지고 있습니다. 사회성이 강하고 지능이 높은 동물로, 육지와 바다를 오가며 생활합니다."
        default:
            return "이 동물에 대한 상세한 정보를 준비 중입니다."
        }
    }
}

struct AnimalDetailCard: View {
    let animalName: String
    let animalSubName: String
    let animalImage: String
    let description: String
    
    var body: some View {
        VStack(spacing: 0) {
            animalImageView
            animalInfoView
        }
        .background(Color.green.opacity(0.3))
        .cornerRadius(20)
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
    }
    
    private var animalInfoView: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(animalName)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
                
                Text(animalSubName)
                    .font(.system(size: 18))
                    .foregroundColor(.black.opacity(0.8))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(description)
                .font(.system(size: 14))
                .lineSpacing(6)
                .foregroundColor(.black.opacity(0.9))
        }
        .padding(20)
    }
}

#Preview {
    NavigationView {
        ExplorerDetailAnimalsView(
            zooTitle: "쿠시로시립동물원",
            zooSubtitle: "홋카이도, 쿠시로시"
        )
    }
    .modelContainer(for: [Animal.self, Facility.self])
} 
