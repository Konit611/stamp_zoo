//
//  MainTabView.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        TabView {
            BingoHomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("bingo_home".localized)
                }
            
            ExplorerView()
                .tabItem {
                    Image(systemName: "safari.fill")
                    Text("explorer".localized)
                }
            
            FieldGuideView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("field_guide".localized)
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("settings".localized)
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
} 