//
//  LocationService.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import Foundation
import CoreLocation
import Combine

class LocationService: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var permissionDenied = false
    @Published var locationError: String?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // 10미터 이상 이동 시 업데이트
    }
    
    /// 위치 권한 요청
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// 위치 업데이트 시작
    func startLocationUpdates() {
        guard authorizationStatus == .authorizedWhenInUse || 
              authorizationStatus == .authorizedAlways else {
            locationError = LocalizationHelper.shared.localizedText(
                korean: "위치 권한이 필요합니다",
                english: "Location permission required",
                japanese: "位置情報の許可が必要です",
                chinese: "需要位置权限"
            )
            return
        }
        
        locationManager.startUpdatingLocation()
    }
    
    /// 위치 업데이트 중지
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    /// 사용자가 시설 범위 내에 있는지 확인
    func isUserInFacilityRange(_ facility: Facility) -> Bool {
        guard let userLocation = currentLocation else { return false }
        
        let facilityLocation = CLLocation(
            latitude: facility.latitude,
            longitude: facility.longitude
        )
        
        let distance = userLocation.distance(from: facilityLocation)
        return distance <= facility.validationRadius
    }
    
    /// 시설까지의 거리 계산 (미터)
    func distanceToFacility(_ facility: Facility) -> Double? {
        guard let userLocation = currentLocation else { return nil }
        
        let facilityLocation = CLLocation(
            latitude: facility.latitude,
            longitude: facility.longitude
        )
        
        return userLocation.distance(from: facilityLocation)
    }
    
    /// 거리를 사용자 친화적인 문자열로 변환
    func formattedDistance(to facility: Facility) -> String? {
        guard let distance = distanceToFacility(facility) else { return nil }
        
        if distance < 1000 {
            return String(format: "%.0fm", distance)
        } else {
            return String(format: "%.1fkm", distance / 1000)
        }
    }
    
    /// 위치 권한 상태 확인
    var hasLocationPermission: Bool {
        return authorizationStatus == .authorizedWhenInUse || 
               authorizationStatus == .authorizedAlways
    }
    
    /// 위치 서비스 사용 가능 여부 확인
    var isLocationServiceEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        locationError = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            permissionDenied = false
            locationError = nil
            startLocationUpdates()
        case .denied, .restricted:
            permissionDenied = true
            locationError = LocalizationHelper.shared.localizedText(
                korean: "위치 권한이 거부되었습니다. 설정에서 권한을 허용해주세요.",
                english: "Location permission denied. Please allow access in Settings.",
                japanese: "位置情報の許可が拒否されました。設定で許可してください。",
                chinese: "位置权限被拒绝。请在设置中允许访问。"
            )
            stopLocationUpdates()
        case .notDetermined:
            permissionDenied = false
            locationError = nil
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = LocalizationHelper.shared.localizedText(
            korean: "위치 정보를 가져올 수 없습니다: \(error.localizedDescription)",
            english: "Unable to get location: \(error.localizedDescription)",
            japanese: "位置情報を取得できません: \(error.localizedDescription)",
            chinese: "无法获取位置信息: \(error.localizedDescription)"
        )
    }
}
