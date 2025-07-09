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
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 제목
                    VStack(alignment: .leading, spacing: 8) {
                        Text("수집한")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("동물도감을 보기")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // 도감 격자
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                        ForEach(0..<30, id: \.self) { index in
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
                            .fill(Color.gray.opacity(0.8))
                            .frame(height: 100)
                        
                        VStack {
                            // 동물 이미지
                            Group {
                                if let image = UIImage(named: animal.image) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } else {
                                    // 기본 동물 이미지
                                    Image(systemName: "pawprint.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(width: 80, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Text(animal.name)
                                .font(.caption2)
                                .foregroundColor(.white)
                                .lineLimit(1)
                        }
                        .padding(8)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                // 빈 도감 슬롯 (검은색 배경) - 클릭 불가
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.black.opacity(0.9))
                        .frame(height: 100)
                        .overlay(
                            VStack {
                                Image(systemName: "questionmark")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                Text("???")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        )
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
}

#Preview {
    FieldGuideView()
        .modelContainer(for: [Animal.self, Facility.self])
}

