//
//  Animal.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import Foundation
import SwiftData

// MARK: - Animal Model
@Model
final class Animal {
    @Attribute(.unique) var id: UUID
    var name: String
    var detail: String
    var image: String
    var stampImage: String
    var bingoNumber: Int?
    var facility: Facility

    init(id: UUID = UUID(), name: String, detail: String, image: String, stampImage: String, bingoNumber: Int? = nil, facility: Facility) {
        self.id = id
        self.name = name
        self.detail = detail
        self.image = image
        self.stampImage = stampImage
        self.bingoNumber = bingoNumber
        self.facility = facility
    }
}

// MARK: - Sample Data
extension Animal {
    static func createSampleAnimals() -> [Animal] {
        // 샘플 시설 생성 - 하나의 Facility 인스턴스만 생성
        let sampleFacility = Facility(
            name: "와쿠와쿠 동물원",
            image: "zoo_main",
            logoImage: "zoo_logo",
            mapImage: "zoo_map",
            mapLink: "https://example.com/map",
            detail: "다양한 동물들과 함께하는 즐거운 동물원입니다."
        )
        
        // 빙고 동물들 (bingoNumber 1-9)
        let bingoAnimals: [Animal] = [
            Animal(
                name: "늑대",
                detail: "무리를 이루어 사냥하는 영리한 동물. 팀워크가 뛰어납니다.",
                image: "wolf_image",
                stampImage: "wolf_stamp",
                bingoNumber: 8,
                facility: sampleFacility
            )
        ]
        
        // 일반 동물들 (빙고에 포함되지 않음)
        let regularAnimals: [Animal] = [
            Animal(
                name: "얼룩말",
                detail: "아프리카의 줄무늬 말. 독특한 패턴으로 유명합니다.",
                image: "zebra_image",
                stampImage: "zebra_stamp",
                facility: sampleFacility
            ),
            Animal(
                name: "하마",
                detail: "아프리카의 강과 호수에 사는 대형 포유류입니다.",
                image: "hippo_image",
                stampImage: "hippo_stamp",
                facility: sampleFacility
            ),
            Animal(
                name: "치타",
                detail: "세계에서 가장 빠른 육상 동물입니다.",
                image: "cheetah_image",
                stampImage: "cheetah_stamp",
                facility: sampleFacility
            ),
            Animal(
                name: "북극곰",
                detail: "북극의 강력한 포식자. 추위에 잘 적응되어 있습니다.",
                image: "polar_bear_image",
                stampImage: "polar_bear_stamp",
                facility: sampleFacility
            ),
            Animal(
                name: "바다사자",
                detail: "물에서 헤엄치는 것을 좋아하는 해양 포유류입니다.",
                image: "sea_lion_image",
                stampImage: "sea_lion_stamp",
                facility: sampleFacility
            )
        ]
        
        return bingoAnimals + regularAnimals
    }
}
