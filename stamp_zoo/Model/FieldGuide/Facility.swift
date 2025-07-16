//
//  Facilities.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import Foundation
import SwiftData

// MARK: - Facility Type Enum
enum FacilityType: String, CaseIterable, Codable {
    case zoo = "zoo"
    case aquarium = "aquarium"
    
    var displayName: String {
        switch self {
        case .zoo:
            return "동물원"
        case .aquarium:
            return "수족관"
        }
    }
}

@Model
final class Facility {
    @Attribute(.unique) var id: UUID
    var name: String
    var type: FacilityType
    var image: String
    var logoImage: String
    var mapImage: String
    var mapLink: String
    var detail: String

    @Relationship(deleteRule: .cascade, inverse: \Animal.facility)
    var animals: [Animal]?

    init(id: UUID = UUID(), name: String, type: FacilityType, image: String, logoImage: String, mapImage: String, mapLink: String, detail: String, animals: [Animal]? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.image = image
        self.logoImage = logoImage
        self.mapImage = mapImage
        self.mapLink = mapLink
        self.detail = detail
        self.animals = animals
    }
}
