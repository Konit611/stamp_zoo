//
//  SampleDataService.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import Foundation
import SwiftData

/// 샘플 데이터 생성을 담당하는 서비스 클래스
class SampleDataService {
    
    /// 샘플 데이터가 이미 로드되었는지 확인
    static func hasSampleData(in context: ModelContext) -> Bool {
        let fetchDescriptor = FetchDescriptor<Animal>()
        let existingAnimals = try? context.fetch(fetchDescriptor)
        return !(existingAnimals?.isEmpty ?? true)
    }
    
    /// 샘플 데이터 로드 (필요한 경우에만)
    static func loadSampleDataIfNeeded(in container: ModelContainer) async {
        let context = ModelContext(container)
        
        // 이미 데이터가 있는지 확인
        if hasSampleData(in: context) {
            return
        }
        
        // 샘플 데이터 생성
        let sampleAnimals = createSampleAnimals()
        
        // Facility 먼저 저장 (중복 방지)
        var savedFacilities: Set<String> = []
        for animal in sampleAnimals {
            if !savedFacilities.contains(animal.facility.name) {
                context.insert(animal.facility)
                savedFacilities.insert(animal.facility.name)
            }
        }
        
        // Animal 데이터 저장
        for animal in sampleAnimals {
            context.insert(animal)
        }
        
        try? context.save()
    }
    
    /// 샘플 동물 데이터 생성
    private static func createSampleAnimals() -> [Animal] {
        // 다양한 시설 생성
        let wakuwakuZoo = Facility(
            name: "쿠시로 동물원",
            type: .zoo,
            location: "홋카이도, 쿠시로시",
            image: "kushiro_facility",
            logoImage: "kushiro_logo",
            mapImage: "kushiro_map",
            mapLink: "https://maps.app.goo.gl/rAE5aqtkyhHjVRZ38",
            detail: "다양한 동물들과 함께하는 즐거운 동물원입니다."
        )
        
        // 빙고 동물들 (bingoNumber 1-9) - 다양한 시설에 분산
        let bingoAnimals: [Animal] = [
            Animal(
                name: "에조시카",
                detail: "에조시카에 대한 설명이 있지롱",
                image: "ezoshika",
                stampImage: "ezoshika_stamp",
                bingoNumber: 1,
                facility: wakuwakuZoo
            ),
        ]
        
        // 일반 동물들 (빙고에 포함되지 않음) - 다양한 시설에 분산
        let regularAnimals: [Animal] = [
        ]
        
        return bingoAnimals + regularAnimals
    }
    
    /// 샘플 시설 데이터만 생성 (테스트용)
    static func createSampleFacilities() -> [Facility] {
        let animals = createSampleAnimals()
        let facilities = Set(animals.map { $0.facility })
        return Array(facilities)
    }
    
    /// 특정 타입의 샘플 데이터만 생성 (확장 가능)
    static func createSampleAnimals(for facilityType: FacilityType) -> [Animal] {
        let allAnimals = createSampleAnimals()
        
        return allAnimals.filter { $0.facility.type == facilityType }
    }
} 
