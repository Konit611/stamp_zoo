//
//  BingoHomeViewModel.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import SwiftUI
import SwiftData
import Foundation

// MARK: - Bingo Stamp Item
struct BingoStamp {
    let animal: Animal?
    let position: Int
    var isCollected: Bool {
        return animal != nil
    }
}

@Observable
class BingoHomeViewModel {
    private var modelContext: ModelContext?
    private var allAnimals: [Animal] = []
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
        loadAnimals()
    }
    
    // MARK: - Computed Properties
    
    /// 9개의 빙고 스탬프 배열 (0-8 인덱스)
    var bingoStamps: [BingoStamp] {
        var stamps: [BingoStamp] = []
        
        // 0-8까지 9개의 빙고 위치 생성
        for position in 0..<9 {
            let bingoNumber = position + 1 // bingoNumber는 1-9
            let animal = bingoAnimals.first { $0.bingoNumber == bingoNumber }
            stamps.append(BingoStamp(animal: animal, position: position))
        }
        
        return stamps
    }
    
    /// bingoNumber가 nil이 아닌 동물들
    var bingoAnimals: [Animal] {
        return allAnimals.filter { $0.bingoNumber != nil }
    }
    
    /// 수집된 스탬프 개수
    var collectedStampsCount: Int {
        return bingoStamps.filter { $0.isCollected }.count
    }
    
    /// 전체 스탬프 개수
    var totalStampsCount: Int {
        return 9
    }
    
    /// 완성률 (퍼센트)
    var completionRate: Int {
        guard totalStampsCount > 0 else { return 0 }
        return Int((Double(collectedStampsCount) / Double(totalStampsCount)) * 100)
    }
    
    /// 빙고 완성 여부
    var isBingoComplete: Bool {
        return collectedStampsCount == totalStampsCount
    }
    
    // MARK: - Methods
    
    /// ModelContext 업데이트
    func updateModelContext(_ newContext: ModelContext) {
        self.modelContext = newContext
        loadAnimals()
    }
    
    /// 동물 데이터 로드
    private func loadAnimals() {
        guard let modelContext = modelContext else { return }
        
        do {
            let descriptor = FetchDescriptor<Animal>()
            allAnimals = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to load animals: \(error)")
            allAnimals = []
        }
    }
    
    /// 데이터 새로고침
    func refresh() {
        loadAnimals()
    }
    
    /// 특정 위치의 스탬프 정보 가져오기
    func getStamp(at position: Int) -> BingoStamp? {
        guard position >= 0 && position < bingoStamps.count else { return nil }
        return bingoStamps[position]
    }
    
    /// 동물 수집 상태 토글 (테스트용)
    func toggleAnimalCollection(at position: Int) {
        // 실제 구현에서는 QR 스캔을 통해 동물을 수집하게 됩니다
        // 여기서는 테스트를 위한 기능만 제공
        loadAnimals()
    }
}

