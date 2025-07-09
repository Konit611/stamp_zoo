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
        }
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    // MARK: - Tab Bar Appearance Setup
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        
        // 탭바 배경색 설정 (zooPointBlack)
        appearance.backgroundColor = UIColor(Color("zooPointBlack"))
        
        // 선택된 탭 색상 설정 (zooPopGreen)
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color("zooPopGreen"))
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color("zooPopGreen"))
        ]
        
        // 선택되지 않은 탭 색상 설정 (zooWhite)
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color("zooWhite"))
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color("zooWhite"))
        ]
        
        // 탭바 그림자/경계선 제거
        appearance.shadowColor = UIColor.clear
        
        // 모든 탭바 appearance에 적용
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
} 