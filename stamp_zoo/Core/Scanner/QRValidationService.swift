//
//  QRValidationService.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import Foundation
import SwiftData
import CoreLocation

enum QRValidationResult {
    case success(animal: Animal, facility: Facility)
    case testSuccess(animal: Animal)
    case alreadyCollected(animal: Animal)
    case invalidLocation(requiredFacility: Facility, distance: Double)
    case invalidCode
    case animalNotFound
    case locationUnavailable
    
    var isSuccess: Bool {
        switch self {
        case .success, .testSuccess:
            return true
        default:
            return false
        }
    }
    
    var localizedMessage: String {
        switch self {
        case .success(let animal, let facility):
            return LocalizationHelper.shared.localizedText(
                korean: "\(animal.name) 스탬프를 획득했습니다! (\(facility.name))",
                english: "Got \(animal.name) stamp! (\(facility.name))",
                japanese: "\(animal.name)のスタンプを獲得しました！(\(facility.name))",
                chinese: "获得了\(animal.name)邮票！(\(facility.name))"
            )
        case .testSuccess(let animal):
            return LocalizationHelper.shared.localizedText(
                korean: "[테스트] \(animal.name) 스탬프를 획득했습니다!",
                english: "[Test] Got \(animal.name) stamp!",
                japanese: "[テスト] \(animal.name)のスタンプを獲得しました！",
                chinese: "[测试] 获得了\(animal.name)邮票！"
            )
        case .alreadyCollected(let animal):
            return LocalizationHelper.shared.localizedText(
                korean: "\(animal.name) 스탬프는 이미 수집되었습니다",
                english: "\(animal.name) stamp already collected",
                japanese: "\(animal.name)のスタンプはすでに収集されています",
                chinese: "\(animal.name)邮票已收集"
            )
        case .invalidLocation(let facility, let distance):
            let distanceText = formatDistance(distance)
            return LocalizationHelper.shared.localizedText(
                korean: "\(facility.name) 근처에서만 스캔 가능합니다 (현재 거리: \(distanceText))",
                english: "Can only scan near \(facility.name) (current distance: \(distanceText))",
                japanese: "\(facility.name)の近くでのみスキャン可能です (現在の距離: \(distanceText))",
                chinese: "只能在\(facility.name)附近扫描 (当前距离: \(distanceText))"
            )
        case .invalidCode:
            return LocalizationHelper.shared.localizedText(
                korean: "유효하지 않은 QR 코드입니다",
                english: "Invalid QR code",
                japanese: "無効なQRコードです",
                chinese: "无效的QR码"
            )
        case .animalNotFound:
            return LocalizationHelper.shared.localizedText(
                korean: "해당 동물을 찾을 수 없습니다",
                english: "Animal not found",
                japanese: "該当する動物が見つかりません",
                chinese: "找不到该动物"
            )
        case .locationUnavailable:
            return LocalizationHelper.shared.localizedText(
                korean: "위치 정보를 사용할 수 없습니다. 위치 권한을 확인해주세요.",
                english: "Location unavailable. Please check location permissions.",
                japanese: "位置情報が利用できません。位置情報の許可を確認してください。",
                chinese: "位置信息不可用。请检查位置权限。"
            )
        }
    }
    
    private func formatDistance(_ distance: Double) -> String {
        if distance < 1000 {
            return String(format: "%.0fm", distance)
        } else {
            return String(format: "%.1fkm", distance / 1000)
        }
    }
}

class QRValidationService {
    private let modelContext: ModelContext
    private let locationService: LocationService
    
    init(modelContext: ModelContext, locationService: LocationService) {
        self.modelContext = modelContext
        self.locationService = locationService
    }
    
    /// QR 코드 검증 메인 함수
    func validateQRCode(_ code: String) -> QRValidationResult {
        // 1. QR 코드 형식 검증
        if code.hasPrefix("stamp_zoo://test/animal/") {
            return validateTestQRCode(code)
        } else if code.hasPrefix("stamp_zoo://facility/") {
            return validateFacilityQRCode(code)
        } else {
            return .invalidCode
        }
    }
    
    /// 테스트용 QR 코드 검증 (위치 제한 없음)
    private func validateTestQRCode(_ code: String) -> QRValidationResult {
        guard let bingoNumber = extractBingoNumber(from: code) else {
            return .invalidCode
        }
        
        guard let animal = findAnimal(by: bingoNumber) else {
            return .animalNotFound
        }
        
        if isAlreadyCollected(bingoNumber: bingoNumber) {
            return .alreadyCollected(animal: animal)
        }
        
        return .testSuccess(animal: animal)
    }
    
    /// 시설용 QR 코드 검증 (위치 제한 있음)
    private func validateFacilityQRCode(_ code: String) -> QRValidationResult {
        // QR 코드 파싱: stamp_zoo://facility/{facilityId}/animal/{bingoNumber}
        let components = code.replacingOccurrences(of: "stamp_zoo://facility/", with: "").split(separator: "/")
        
        guard components.count == 3,
              !components[0].isEmpty,
              components[1] == "animal",
              let bingoNumber = Int(components[2]) else {
            return .invalidCode
        }
        
        let facilityId = String(components[0])
        
        guard let animal = findAnimal(by: bingoNumber) else {
            return .animalNotFound
        }
        
        guard let facility = findFacility(by: facilityId) else {
            return .invalidCode
        }
        
        if isAlreadyCollected(bingoNumber: bingoNumber) {
            return .alreadyCollected(animal: animal)
        }
        
        // 위치 검증
        guard locationService.hasLocationPermission else {
            return .locationUnavailable
        }
        
        guard locationService.currentLocation != nil else {
            return .locationUnavailable
        }
        
        if !locationService.isUserInFacilityRange(facility) {
            let distance = locationService.distanceToFacility(facility) ?? 0
            return .invalidLocation(requiredFacility: facility, distance: distance)
        }
        
        return .success(animal: animal, facility: facility)
    }
    
    /// 스탬프 수집 처리
    func collectStamp(result: QRValidationResult, qrCode: String) -> Bool {
        guard result.isSuccess else { return false }
        
        let bingoNumber: Int
        let facilityName: String
        let isTestCollection: Bool
        
        switch result {
        case .success(let animal, let facility):
            bingoNumber = animal.bingoNumber ?? 0
            facilityName = facility.name
            isTestCollection = false
        case .testSuccess(let animal):
            bingoNumber = animal.bingoNumber ?? 0
            facilityName = "Test"
            isTestCollection = true
        default:
            return false
        }
        
        let userLocation = locationService.currentLocation
        let stampCollection = StampCollection(
            bingoNumber: bingoNumber,
            qrCode: qrCode,
            facilityName: facilityName,
            userLatitude: userLocation?.coordinate.latitude,
            userLongitude: userLocation?.coordinate.longitude,
            isTestCollection: isTestCollection
        )
        
        modelContext.insert(stampCollection)
        
        do {
            try modelContext.save()
            return true
        } catch {
            print("Failed to save stamp collection: \(error)")
            return false
        }
    }
    
    // MARK: - Helper Methods
    
    /// QR 코드에서 빙고 번호 추출
    private func extractBingoNumber(from code: String) -> Int? {
        guard let lastComponent = code.split(separator: "/").last else { return nil }
        return Int(lastComponent)
    }
    
    /// 빙고 번호로 동물 찾기
    private func findAnimal(by bingoNumber: Int) -> Animal? {
        let descriptor = FetchDescriptor<Animal>(
            predicate: #Predicate<Animal> { animal in
                animal.bingoNumber == bingoNumber
            }
        )
        return try? modelContext.fetch(descriptor).first
    }
    
    /// 시설 ID로 시설 찾기
    private func findFacility(by facilityId: String) -> Facility? {
        let descriptor = FetchDescriptor<Facility>(
            predicate: #Predicate<Facility> { facility in
                facility.facilityId == facilityId
            }
        )
        return try? modelContext.fetch(descriptor).first
    }
    
    /// 해당 빙고 번호가 이미 수집되었는지 확인
    private func isAlreadyCollected(bingoNumber: Int) -> Bool {
        let descriptor = FetchDescriptor<StampCollection>(
            predicate: #Predicate<StampCollection> { collection in
                collection.bingoNumber == bingoNumber
            }
        )
        let collections = try? modelContext.fetch(descriptor)
        return !(collections?.isEmpty ?? true)
    }
    
    /// 모든 수집된 스탬프 가져오기
    func getAllCollectedStamps() -> [StampCollection] {
        let descriptor = FetchDescriptor<StampCollection>(
            sortBy: [SortDescriptor(\.collectedAt, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    /// 특정 빙고 번호가 수집되었는지 확인
    func isStampCollected(bingoNumber: Int) -> Bool {
        return isAlreadyCollected(bingoNumber: bingoNumber)
    }
}
