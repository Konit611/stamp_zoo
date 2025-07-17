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
            if !savedFacilities.contains(animal.facility.nameKo) {
                context.insert(animal.facility)
                savedFacilities.insert(animal.facility.nameKo)
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
        // 다양한 시설 생성 (다국어 지원)
        let kushiroZoo = Facility(
            nameKo: "쿠시로시 동물원",
            nameEn: "Kushiro City Zoo",
            nameJa: "釧路市動物園",
            nameZh: "钏路市动物园",
            type: .zoo,
            locationKo: "홋카이도, 쿠시로시",
            locationEn: "Hokkaido, Kushiro City",
            locationJa: "北海道、釧路市",
            locationZh: "北海道，钏路市",
            image: "kushiro_facility",
            logoImage: "kushiro_logo",
            mapImage: "kushiro_map",
            mapLink: "https://maps.app.goo.gl/rAE5aqtkyhHjVRZ38",
            detailKo: "홋카이도의 자연과 함께하는 아름다운 동물원입니다. 에조시카를 비롯한 다양한 동물들을 만날 수 있습니다.",
            detailEn: "A beautiful zoo with the nature of Hokkaido. You can meet various animals including Ezo deer.",
            detailJa: "北海道の自然と共にある美しい動物園です。エゾシカをはじめとする様々な動物に出会えます。",
            detailZh: "与北海道大自然共存的美丽动物园。可以见到虾夷鹿等各种动物。"
        )
        
        // 빙고 동물들 (bingoNumber 1-9) - 다양한 시설에 분산
        let bingoAnimals: [Animal] = [
            Animal(
                nameKo: "에조시카",
                nameEn: "Ezo Deer",
                nameJa: "エゾシカ",
                nameZh: "虾夷鹿",
                detailKo: "홋카이도에 서식하는 일본 고유의 사슴으로, 아름다운 뿔이 특징입니다.",
                detailEn: "A native Japanese deer that lives in Hokkaido, characterized by beautiful antlers.",
                detailJa: "北海道に生息する日本固有の鹿で、美しい角が特徴です。",
                detailZh: "栖息在北海道的日本特有鹿类，以美丽的鹿角为特征。",
                image: "ezoshika",
                stampImage: "ezoshika_stamp",
                bingoNumber: 1,
                facility: kushiroZoo
            ),
        ]
        
        // 일반 동물들 (빙고에 포함되지 않음)
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
