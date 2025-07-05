import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showLanguageSettings = false
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.black)
                        .clipShape(Circle())
                }
            }
        }
        .sheet(isPresented: $showLanguageSettings) {
            LanguageSettingsView()
        }
    }
}

#Preview {
    SettingsView()
} 
