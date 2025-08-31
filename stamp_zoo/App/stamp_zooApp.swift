//
//  stamp_zooApp.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import SwiftUI
import SwiftData

@main
struct stamp_zooApp: App {
    @StateObject private var localizationManager = LocalizationManager.shared
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            Animal.self,
            Facility.self,
            StampCollection.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            // 샘플 데이터 로드 체크
            Task {
                await loadSampleDataIfNeeded(container: container)
            }
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
    
    // MARK: - Sample Data Loading
    private static func loadSampleDataIfNeeded(container: ModelContainer) async {
        await SampleDataService.loadSampleDataIfNeeded(in: container)
    }
}
