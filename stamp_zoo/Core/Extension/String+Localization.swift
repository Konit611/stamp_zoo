import Foundation

extension String {
    /// 다언어 문자열 반환
    var localized: String {
        return LocalizationManager.shared.localizedString(for: self)
    }
    
    /// 다언어 문자열 반환 (인자 포함)
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
} 