//
//  FieldGuideView.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import SwiftUI
import SwiftData

struct FieldGuideView: View {
    @Query private var animals: [Animal]
    @StateObject private var localizationHelper = LocalizationHelper.shared
    
    // 도감 슬롯 계산 (최소 12개, 3의 배수로 맞춤)
    private var totalFieldGuideSlots: Range<Int> {
        let animalCount = animals.count
        let minSlots = 12
        let slotsNeeded = max(animalCount + 6, minSlots) // 현재 동물 + 여유분 또는 최소 개수
        let roundedSlots = ((slotsNeeded + 2) / 3) * 3 // 3의 배수로 맞춤
        return 0..<roundedSlots
    }
    

    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 제목
                    VStack(alignment: .leading, spacing: 8) {
                        Text(localizationHelper.localizedText(
                            korean: "수집한",
                            english: "Collected",
                            japanese: "収集した",
                            chinese: "收集的"
                        ))
                            .font(.title)
                            .fontWeight(.bold)
                        Text(localizationHelper.localizedText(
                            korean: "동물도감을 보기",
                            english: "Animal Guide",
                            japanese: "動物図鑑を見る",
                            chinese: "动物图鉴"
                        ))
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // 도감 격자
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                        ForEach(totalFieldGuideSlots, id: \.self) { index in
                            animalCell(for: index)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
            .background(Color(.systemGray6))
        }
    }
    
    // MARK: - Animal Cell
    private func animalCell(for index: Int) -> some View {
        let animal = getAnimal(at: index)
        
        return Group {
            if let animal = animal {
                // 수집된 동물 - 클릭 가능
                NavigationLink(destination: FieldGuideDetailView(animal: animal)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(isAnimalCollected(animal) ? Color("zooBackgroundBlack").opacity(0.8) : Color.gray.opacity(0.5))
                            .frame(height: 100)
                        
                        // 모든 동물 이미지 표시 (수집 여부에 관계없이)
                        VStack(spacing: 4) {
                            ZStack {
                                // 동물 이미지
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
                                .padding(12)
                                
                                // 미수집된 동물은 어두운 오버레이 추가
                                if !isAnimalCollected(animal) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.7))
                                        .frame(width: 70, height: 60)
                                        .overlay(
                                            Image(systemName: "questionmark")
                                                .font(.title2)
                                                .foregroundColor(.white)
                                        )
                                }
                            }
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                // 빈 도감 슬롯 - 클릭 불가
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color("zooBackgroundBlack"))
                        .frame(height: 100)
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    private func getAnimal(at index: Int) -> Animal? {
        // 처음 몇 개만 동물로 표시하고 나머지는 비어있는 상태로
        if index < animals.count {
            return animals[index]
        }
        return nil
    }
    
    private func isAnimalCollected(_ animal: Animal) -> Bool {
        // 빙고 번호가 있으면 수집된 것으로 간주
        return animal.bingoNumber != nil
    }
}

#Preview {
    FieldGuideView()
        .modelContainer(for: [Animal.self, Facility.self])
}

