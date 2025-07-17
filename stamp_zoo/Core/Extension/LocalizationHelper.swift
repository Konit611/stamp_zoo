import Foundation
import SwiftUI
import Combine

class LocalizationHelper: ObservableObject {
    static let shared = LocalizationHelper()
    
    @Published var currentLanguage: String = ""
    private var localizationManager = LocalizationManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    enum SupportedLanguage: String, CaseIterable {
        case korean = "ko"
        case english = "en"
        case japanese = "ja"
        case chinese = "zh"
        
        static func current(from languageCode: String) -> SupportedLanguage {
            switch languageCode {
            case "ko":
                return .korean
            case "en":
                return .english
            case "ja":
                return .japanese
            case "zh":
                return .chinese
            default:
                // fallback: 시스템 언어 확인
                let systemLanguage = Locale.current.language.languageCode?.identifier ?? "en"
                switch systemLanguage {
                case "ko":
                    return .korean
                case "ja":
                    return .japanese
                case "zh", "zh-Hans", "zh-Hant":
                    return .chinese
                default:
                    return .english
                }
            }
        }
        
        var current: SupportedLanguage {
            return SupportedLanguage.current(from: LocalizationManager.shared.currentLanguage)
        }
    }
    
    private init() {
        // 현재 언어로 초기화
        currentLanguage = localizationManager.currentLanguage
        
        // LocalizationManager의 변화를 감지
        LocalizationManager.shared.$currentLanguage
            .sink { [weak self] newLanguage in
                DispatchQueue.main.async {
                    self?.currentLanguage = newLanguage
                }
            }
            .store(in: &cancellables)
    }
    
    /// 지원하는 언어에 따라 적절한 텍스트를 반환합니다
    func localizedText(
        korean: String,
        english: String,
        japanese: String,
        chinese: String
    ) -> String {
        // currentLanguage @Published 변수를 사용하여 변화 감지 확실히 함
        let currentLang = SupportedLanguage.current(from: currentLanguage)
        
        switch currentLang {
        case .korean:
            return korean
        case .english:
            return english
        case .japanese:
            return japanese
        case .chinese:
            return chinese
        }
    }
    
    /// 정적 메서드 (기존 호환성을 위해 유지)
    static func localizedText(
        korean: String,
        english: String,
        japanese: String,
        chinese: String
    ) -> String {
        // 항상 최신 언어 정보를 사용
        let currentLang = SupportedLanguage.current(from: LocalizationManager.shared.currentLanguage)
        
        switch currentLang {
        case .korean:
            return korean
        case .english:
            return english
        case .japanese:
            return japanese
        case .chinese:
            return chinese
        }
    }
} 