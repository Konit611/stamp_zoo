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
    let isCollected: Bool
}

@Observable
class BingoHomeViewModel {
    private var modelContext: ModelContext?
    private var allAnimals: [Animal] = []
    private var allBingoAnimals: [BingoAnimal] = []
    private var collectedStamps: [StampCollection] = []
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
        loadAnimals()
        loadBingoAnimals()
        loadCollectedStamps()
    }
    
    // MARK: - Computed Properties
    
    /// 9개의 빙고 스탬프 배열 (0-8 인덱스)
    var bingoStamps: [BingoStamp] {
        var stamps: [BingoStamp] = []
        
        // 0-8까지 9개의 빙고 위치 생성
        for position in 0..<9 {
            let bingoNumber = position + 1 // bingoNumber는 1-9
            let animal = getAnimal(for: bingoNumber)
            let isCollected = collectedStamps.contains { $0.bingoNumber == bingoNumber }
            stamps.append(BingoStamp(animal: animal, position: position, isCollected: isCollected))
        }
        
        return stamps
    }
    
    /// 빙고에 포함된 동물들
    var bingoAnimals: [Animal] {
        return allBingoAnimals.compactMap { bingoAnimal in
            getAnimal(by: bingoAnimal.animalId)
        }
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
        loadBingoAnimals()
        loadCollectedStamps()
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
    
    /// 빙고 동물 데이터 로드
    private func loadBingoAnimals() {
        guard let modelContext = modelContext else { return }
        
        do {
            let descriptor = FetchDescriptor<BingoAnimal>()
            allBingoAnimals = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to load bingo animals: \(error)")
            allBingoAnimals = []
        }
    }
    
    /// 데이터 새로고침
    func refresh() {
        loadAnimals()
        loadBingoAnimals()
        loadCollectedStamps()
    }
    
    /// 특정 위치의 스탬프 정보 가져오기
    func getStamp(at position: Int) -> BingoStamp? {
        guard position >= 0 && position < bingoStamps.count else { return nil }
        return bingoStamps[position]
    }
    
    /// 수집된 스탬프 데이터 로드
    private func loadCollectedStamps() {
        guard let modelContext = modelContext else { return }
        
        do {
            let descriptor = FetchDescriptor<StampCollection>()
            collectedStamps = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to load collected stamps: \(error)")
            collectedStamps = []
        }
    }
    
    /// QR 스캔을 통한 스탬프 수집
    func collectStamp(bingoNumber: Int, qrCode: String, facilityName: String, isTestCollection: Bool = false) {
        guard let modelContext = modelContext else { return }
        
        // 이미 수집된 스탬프인지 확인
        let alreadyCollected = collectedStamps.contains { $0.bingoNumber == bingoNumber }
        if alreadyCollected {
            return
        }
        
        // 새로운 스탬프 수집 기록 생성
        let newCollection = StampCollection(
            bingoNumber: bingoNumber,
            qrCode: qrCode,
            facilityName: facilityName,
            isTestCollection: isTestCollection
        )
        
        modelContext.insert(newCollection)
        
        do {
            try modelContext.save()
            loadCollectedStamps() // 새로고침
        } catch {
            print("Failed to save stamp collection: \(error)")
        }
    }
    
    /// 특정 빙고 번호의 스탬프가 수집되었는지 확인
    func isStampCollected(bingoNumber: Int) -> Bool {
        return collectedStamps.contains { $0.bingoNumber == bingoNumber }
    }
    
    /// 수집된 스탬프 정보 가져오기
    func getCollectedStamp(bingoNumber: Int) -> StampCollection? {
        return collectedStamps.first { $0.bingoNumber == bingoNumber }
    }
    
    /// 모든 수집된 스탬프 가져오기 (최신순)
    var allCollectedStamps: [StampCollection] {
        return collectedStamps.sorted { $0.collectedAt > $1.collectedAt }
    }
    
    /// 빙고 번호로 동물 찾기
    private func getAnimal(for bingoNumber: Int) -> Animal? {
        guard let bingoAnimal = allBingoAnimals.first(where: { $0.bingoNumber == bingoNumber }) else {
            return nil
        }
        return getAnimal(by: bingoAnimal.animalId)
    }
    
    /// 동물 ID로 동물 찾기
    private func getAnimal(by animalId: String) -> Animal? {
        return allAnimals.first { $0.id.uuidString == animalId }
    }
}

