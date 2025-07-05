import SwiftUI

struct SettingsView: View {
    @State private var showLanguageSettings = false
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.blue)
                        Text("language_settings".localized)
                        Spacer()
                        Text(localizationManager.supportedLanguageNames[localizationManager.currentLanguage] ?? "")
                            .foregroundColor(.secondary)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showLanguageSettings = true
                    }
                }
                
                Section {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                        Text("about_app".localized)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("settings".localized)
            .sheet(isPresented: $showLanguageSettings) {
                LanguageSettingsView()
            }
        }
    }
}

#Preview {
    SettingsView()
} 