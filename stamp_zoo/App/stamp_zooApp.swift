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
            Facility.self
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
        let context = ModelContext(container)
        
        // 이미 데이터가 있는지 확인
        let fetchDescriptor = FetchDescriptor<Animal>()
        let existingAnimals = try? context.fetch(fetchDescriptor)
        
        if existingAnimals?.isEmpty ?? true {
            // 샘플 데이터 생성
            let sampleAnimals = Animal.createSampleAnimals()
            
            // Facility 먼저 저장 (중복 방지)
            var savedFacilities: Set<String> = []
            for animal in sampleAnimals {
                if !savedFacilities.contains(animal.facility.name) {
                    context.insert(animal.facility)
                    savedFacilities.insert(animal.facility.name)
                }
            }
            
            // Animal 데이터 저장
            for animal in sampleAnimals {
                context.insert(animal)
            }
            
            try? context.save()
        }
    }
}
