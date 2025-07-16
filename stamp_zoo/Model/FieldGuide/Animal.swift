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


