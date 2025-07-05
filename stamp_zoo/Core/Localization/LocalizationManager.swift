import Foundation
import SwiftUI

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: String = "ko" {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "selected_language")
        }
    }
    
    private init() {
        // 저장된 언어 설정 불러오기
        if let savedLanguage = UserDefaults.standard.string(forKey: "selected_language") {
            currentLanguage = savedLanguage
        } else {
            // 기본 언어는 시스템 언어 또는 한국어
            currentLanguage = Locale.preferredLanguages.first?.components(separatedBy: "-").first ?? "ko"
        }
    }
    
    func localizedString(for key: String) -> String {
        guard let bundle = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
              let langBundle = Bundle(path: bundle) else {
            return key
        }
        
        let localizedString = langBundle.localizedString(forKey: key, value: nil, table: nil)
        return localizedString == key ? key : localizedString
    }
    
    func setLanguage(_ language: String) {
        currentLanguage = language
    }
    
    var supportedLanguages: [String] {
        return ["ko", "en", "ja"]
    }
    
    var supportedLanguageNames: [String: String] {
        return [
            "ko": "한국어",
            "en": "English",
            "ja": "日本語"
        ]
    }
} 