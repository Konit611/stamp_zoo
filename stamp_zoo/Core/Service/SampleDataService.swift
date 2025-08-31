//
//  SampleDataService.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import Foundation
import SwiftData

/// 샘플 데이터 생성을 담당하는 서비스 클래스
class SampleDataService {
    
    /// 샘플 데이터가 이미 로드되었는지 확인
    static func hasSampleData(in context: ModelContext) -> Bool {
        let fetchDescriptor = FetchDescriptor<Animal>()
        let existingAnimals = try? context.fetch(fetchDescriptor)
        return !(existingAnimals?.isEmpty ?? true)
    }
    
    /// 샘플 데이터 로드 (필요한 경우에만)
    static func loadSampleDataIfNeeded(in container: ModelContainer) async {
        let context = ModelContext(container)
        
        // 이미 데이터가 있는지 확인
        if hasSampleData(in: context) {
            return
        }
        
        // 샘플 데이터 생성
        let sampleAnimals = createSampleAnimals()
        
        // Facility 먼저 저장 (중복 방지)
        var savedFacilities: Set<String> = []
        for animal in sampleAnimals {
            if !savedFacilities.contains(animal.facility.nameKo) {
                context.insert(animal.facility)
                savedFacilities.insert(animal.facility.nameKo)
            }
        }
        
        // Animal 데이터 저장
        for animal in sampleAnimals {
            context.insert(animal)
        }
        
        try? context.save()
    }
    
    /// 샘플 동물 데이터 생성
    private static func createSampleAnimals() -> [Animal] {
        // 다양한 시설 생성 (다국어 지원 + GPS 좌표)
        let kushiroZoo = Facility(
            nameKo: "쿠시로시 동물원",
            nameEn: "Kushiro City Zoo",
            nameJa: "釧路市動物園",
            nameZh: "钏路市动物园",
            type: .zoo,
            locationKo: "홋카이도, 쿠시로시",
            locationEn: "Hokkaido, Kushiro City",
            locationJa: "北海道、釧路市",
            locationZh: "北海道，钏路市",
            image: "kushiro_facility",
            logoImage: "kushiro_logo",
            mapImage: "kushiro_map",
            mapLink: "https://maps.app.goo.gl/rAE5aqtkyhHjVRZ38",
            detailKo: "홋카이도의 자연과 함께하는 아름다운 동물원입니다. 에조시카를 비롯한 다양한 동물들을 만날 수 있습니다.",
            detailEn: "A beautiful zoo with the nature of Hokkaido. You can meet various animals including Ezo deer.",
            detailJa: "北海道の自然と共にある美しい動物園です。エゾシカをはじめとする様々な動物に出会えます。",
            detailZh: "与北海道大自然共存的美丽动物园。可以见到虾夷鹿等各种动物。",
            latitude: 42.9849,
            longitude: 144.3822,
            validationRadius: 500.0,
            facilityId: "kushiro"
        )
        
        // 삿포로시 마루야마 동물원
        let maruyamaZoo = Facility(
            nameKo: "삿포로시 마루야마 동물원",
            nameEn: "Sapporo Maruyama Zoo",
            nameJa: "札幌市円山動物園",
            nameZh: "札幌市圆山动物园",
            type: .zoo,
            locationKo: "홋카이도, 삿포로시",
            locationEn: "Hokkaido, Sapporo City",
            locationJa: "北海道、札幌市",
            locationZh: "北海道，札幌市",
            image: "maruyama_facility",
            logoImage: "maruyama_logo",
            mapImage: "maruyama_map",
            mapLink: "https://www.city.sapporo.jp/zoo/",
            detailKo: "삿포로 시내에 위치한 역사 깊은 동물원으로, 북극곰과 다양한 동물들을 만날 수 있습니다.",
            detailEn: "A historic zoo located in Sapporo city where you can meet polar bears and various animals.",
            detailJa: "札幌市内にある歴史ある動物園で、ホッキョクグマをはじめ様々な動物に出会えます。",
            detailZh: "位于札幌市内的历史悠久动物园，可以见到北极熊等各种动物。",
            latitude: 43.0519,
            longitude: 141.3152,
            validationRadius: 300.0,
            facilityId: "maruyama"
        )
        
        // 아사히카와시 아사히야마 동물원
        let asahiyamaZoo = Facility(
            nameKo: "아사히카와시 아사히야마 동물원",
            nameEn: "Asahiyama Zoo",
            nameJa: "旭川市旭山動物園",
            nameZh: "旭川市旭山动物园",
            type: .zoo,
            locationKo: "홋카이도, 아사히카와시",
            locationEn: "Hokkaido, Asahikawa City",
            locationJa: "北海道、旭川市",
            locationZh: "北海道，旭川市",
            image: "asahiyama_facility",
            logoImage: "asahiyama_logo",
            mapImage: "asahiyama_map",
            mapLink: "https://www.city.asahikawa.hokkaido.jp/asahiyamazoo/",
            detailKo: "동물들의 자연스러운 행동을 관찰할 수 있는 혁신적인 전시 방식으로 유명한 동물원입니다.",
            detailEn: "A zoo famous for its innovative exhibition methods that allow visitors to observe animals' natural behaviors.",
            detailJa: "動物たちの自然な行動を観察できる革新的な展示方式で有名な動物園です。",
            detailZh: "以能够观察动物自然行为的创新展示方式而闻名的动物园。",
            latitude: 43.7711,
            longitude: 142.4553,
            validationRadius: 400.0,
            facilityId: "asahiyama"
        )
        
        // // 오비히로 동물원
        // let obihiroZoo = Facility(
        //     nameKo: "오비히로 동물원",
        //     nameEn: "Obihiro Zoo",
        //     nameJa: "帯広動物園",
        //     nameZh: "带广动物园",
        //     type: .zoo,
        //     locationKo: "홋카이도, 오비히로시",
        //     locationEn: "Hokkaido, Obihiro City",
        //     locationJa: "北海道、帯広市",
        //     locationZh: "北海道，带广市",
        //     image: "obihiro_facility",
        //     logoImage: "obihiro_logo",
        //     mapImage: "obihiro_map",
        //     mapLink: "https://www.obihirozoo.jp/",
        //     detailKo: "아름다운 자연 환경 속에서 다양한 동물들과 만날 수 있는 가족친화적인 동물원입니다.",
        //     detailEn: "A family-friendly zoo where you can meet various animals in a beautiful natural environment.",
        //     detailJa: "美しい自然環境の中で様々な動物たちと出会える家族向けの動物園です。",
        //     detailZh: "在美丽的自然环境中可以与各种动物相遇的家庭友好型动物园。"
        // )
        
         // 오타루 수족관
         let otaruAquarium = Facility(
             nameKo: "오타루 수족관",
             nameEn: "Otaru Aquarium",
             nameJa: "小樽水族館",
             nameZh: "小樽水族馆",
             type: .aquarium,
             locationKo: "홋카이도, 오타루시",
             locationEn: "Hokkaido, Otaru City",
             locationJa: "北海道、小樽市",
             locationZh: "北海道，小樽市",
             image: "otaru_facility",
             logoImage: "otaru_logo",
             mapImage: "otaru_map",
             mapLink: "https://otaru-aq.jp/",
             detailKo: "바다를 바라보며 즐길 수 있는 아름다운 수족관으로, 점박이바다표범을 만날 수 있습니다.",
             detailEn: "A beautiful aquarium with ocean views where you can meet spotted seals.",
             detailJa: "海を眺めながら楽しめる美しい水族館で、ゴマフアザラシに出会えます。",
             detailZh: "可以眺望大海享受美景的美丽水族馆，可以遇见斑海豹。",
             latitude: 43.1907,
             longitude: 140.9947,
             validationRadius: 200.0,
             facilityId: "otaru"
         )
        
        // // 신삿포로산피아자수족관
        // let sunpiazaAquarium = Facility(
        //     nameKo: "신삿포로산피아자수족관",
        //     nameEn: "Shin-Chitose Airport Sunpiazza Aquarium",
        //     nameJa: "新千歳空港サンピアザ水族館",
        //     nameZh: "新千岁机场太阳广场水族馆",
        //     type: .aquarium,
        //     locationKo: "홋카이도, 치토세시",
        //     locationEn: "Hokkaido, Chitose City",
        //     locationJa: "北海道、千歳市",
        //     locationZh: "北海道，千岁市",
        //     image: "sunpiaza_facility",
        //     logoImage: "sunpiaza_logo",
        //     mapImage: "sunpiaza_map",
        //     mapLink: "https://www.sunpiazza-aquarium.com/",
        //     detailKo: "공항 근처에 위치한 접근성 좋은 수족관으로, 다양한 해양생물을 관찰할 수 있습니다.",
        //     detailEn: "An easily accessible aquarium near the airport where you can observe various marine life.",
        //     detailJa: "空港近くにある利便性の良い水族館で、様々な海洋生物を観察できます。",
        //     detailZh: "位于机场附近交通便利的水族馆，可以观察各种海洋生物。"
        // )
        
        // // 토우베츠마린파크닉스
        // let marinenickAquarium = Facility(
        //     nameKo: "토우베츠마린파크닉스",
        //     nameEn: "Noboribetsu Marine Park Nixe",
        //     nameJa: "登別マリンパークニクス",
        //     nameZh: "登别海洋公园尼克斯",
        //     type: .aquarium,
        //     locationKo: "홋카이도, 노보리베츠시",
        //     locationEn: "Hokkaido, Noboribetsu City",
        //     locationJa: "北海道、登別市",
        //     locationZh: "北海道，登别市",
        //     image: "marinenik_facility",
        //     logoImage: "marinenik_logo",
        //     mapImage: "marinenik_map",
        //     mapLink: "https://www.nixe.co.jp/",
        //     detailKo: "성처럼 아름다운 외관의 수족관으로, 펭귄 퍼레이드가 인기입니다.",
        //     detailEn: "An aquarium with a beautiful castle-like exterior, famous for its penguin parade.",
        //     detailJa: "お城のような美しい外観の水族館で、ペンギンパレードが人気です。",
        //     detailZh: "外观如城堡般美丽的水族馆，企鹅游行很受欢迎。"
        // )
        
        // // 사케노우라사토치토세수족관
        // let chitoseAquarium = Facility(
        //     nameKo: "사케노우라사토치토세수족관",
        //     nameEn: "Chitose Salmon Aquarium",
        //     nameJa: "サケのふるさと千歳水族館",
        //     nameZh: "鲑鱼故乡千岁水族馆",
        //     type: .aquarium,
        //     locationKo: "홋카이도, 치토세시",
        //     locationEn: "Hokkaido, Chitose City",
        //     locationJa: "北海道、千歳市",
        //     locationZh: "北海道，千岁市",
        //     image: "chitose_facility",
        //     logoImage: "chitose_logo",
        //     mapImage: "chitose_map",
        //     mapLink: "https://chitose-aq.jp/",
        //     detailKo: "연어를 주제로 한 특별한 수족관으로, 홋카이도의 대표 물고기를 만날 수 있습니다.",
        //     detailEn: "A special aquarium themed around salmon, where you can meet Hokkaido's representative fish.",
        //     detailJa: "サケをテーマにした特別な水族館で、北海道の代表的な魚に出会えます。",
        //     detailZh: "以鲑鱼为主题的特别水族馆，可以遇见北海道的代表性鱼类。"
        // )
        
        // // AOAO SAPPORO
        // let aoaoSapporo = Facility(
        //     nameKo: "AOAO SAPPORO",
        //     nameEn: "AOAO SAPPORO",
        //     nameJa: "AOAO SAPPORO",
        //     nameZh: "AOAO SAPPORO",
        //     type: .aquarium,
        //     locationKo: "홋카이도, 삿포로시",
        //     locationEn: "Hokkaido, Sapporo City",
        //     locationJa: "北海道、札幌市",
        //     locationZh: "北海道，札幌市",
        //     image: "aoao_facility",
        //     logoImage: "aoao_logo",
        //     mapImage: "aoao_map",
        //     mapLink: "https://aoao-sapporo.blue/",
        //     detailKo: "삿포로의 최신 도심형 수족관으로, 현대적이고 혁신적인 전시를 선보입니다.",
        //     detailEn: "Sapporo's newest urban aquarium featuring modern and innovative exhibitions.",
        //     detailJa: "札幌の最新都市型水族館で、現代的で革新的な展示を行っています。",
        //     detailZh: "札幌最新的都市型水族馆，展示现代而创新的内容。"
        // )
        
        // 빙고 동물들 (bingoNumber 1-9) - 다양한 시설에 분산
        let bingoAnimals: [Animal] = [
            // 쿠시로시 동물원
            Animal(
                nameKo: "에조시카",
                nameEn: "Ezo Deer",
                nameJa: "エゾシカ",
                nameZh: "虾夷鹿",
                detailKo: "홋카이도에 서식하는 일본 고유의 사슴으로, 아름다운 뿔이 특징입니다.",
                detailEn: "A native Japanese deer that lives in Hokkaido, characterized by beautiful antlers.",
                detailJa: "北海道に生息する日本固有の鹿で、美しい角が特徴です。",
                detailZh: "栖息在北海道的日本特有鹿类，以美丽的鹿角为特征。",
                image: "ezoshika",
                stampImage: "ezoshika_stamp",
                bingoNumber: 1,
                facility: kushiroZoo
            ),
            
            // 삿포로시 마루야마 동물원
            Animal(
                nameKo: "북극곰",
                nameEn: "Polar Bear",
                nameJa: "ホッキョクグマ",
                nameZh: "北极熊",
                detailKo: "세계에서 가장 큰 육식 동물로, 추위에 강한 하얀 털을 가지고 있습니다.",
                detailEn: "The world's largest carnivorous animal with white fur that is resistant to cold.",
                detailJa: "世界最大の肉食動物で、寒さに強い白い毛を持っています。",
                detailZh: "世界上最大的肉食动物，拥有抗寒的白色毛发。",
                image: "polar_bear",
                stampImage: "polar_bear_stamp",
                bingoNumber: 2,
                facility: maruyamaZoo
            ),
            
            // 아사히카와시 아사히야마 동물원
            Animal(
                nameKo: "킹펭귄",
                nameEn: "King Penguin",
                nameJa: "キングペンギン",
                nameZh: "王企鹅",
                detailKo: "황제펭귄 다음으로 큰 펭귄으로, 목 주변의 주황색 무늬가 아름답습니다.",
                detailEn: "The second largest penguin species, beautiful with orange markings around the neck.",
                detailJa: "皇帝ペンギンに次いで大きなペンギンで、首周りのオレンジ色の模様が美しいです。",
                detailZh: "仅次于皇帝企鹅的大型企鹅，颈部周围的橙色花纹很美丽。",
                image: "king_penguin",
                stampImage: "king_penguin_stamp",
                bingoNumber: 3,
                facility: asahiyamaZoo
            ),
            
            // // 오비히로 동물원
            // Animal(
            //     nameKo: "에조리스",
            //     nameEn: "Ezo Squirrel",
            //     nameJa: "エゾリス",
            //     nameZh: "虾夷松鼠",
            //     detailKo: "홋카이도에 서식하는 귀여운 다람쥐로, 겨울에는 털색이 회색으로 변합니다.",
            //     detailEn: "A cute squirrel native to Hokkaido whose fur turns gray in winter.",
            //     detailJa: "北海道に生息するかわいいリスで、冬になると毛色が灰色に変わります。",
            //     detailZh: "栖息在北海道的可爱松鼠，冬天毛色会变成灰色。",
            //     image: "ezo_squirrel",
            //     stampImage: "ezo_squirrel_stamp",
            //     bingoNumber: 4,
            //     facility: obihiroZoo
            // ),
            
            // 오타루 수족관
            Animal(
                nameKo: "점박이바다표범",
                nameEn: "Spotted Seal",
                nameJa: "ゴマフアザラシ",
                nameZh: "斑海豹",
                detailKo: "홋카이도 연안에서 볼 수 있는 바다표범으로, 몸에 있는 점무늬가 특징입니다.",
                detailEn: "A seal species found in Hokkaido's coastal waters, characterized by spotted patterns on their body.",
                detailJa: "北海道沿岸で見ることができるアザラシで、体にある斑点模様が特徴です。",
                detailZh: "在北海道沿岸可以看到的海豹，以身体上的斑点花纹为特征。",
                image: "spotted_seal",
                stampImage: "spotted_seal_stamp",
                bingoNumber: 5,
                facility: otaruAquarium
            ),
            
            // // 신삿포로산피아자수족관
            // Animal(
            //     nameKo: "바다표범",
            //     nameEn: "Seal",
            //     nameJa: "アザラシ",
            //     nameZh: "海豹",
            //     detailKo: "물속에서 우아하게 헤엄치는 해양 포유류로, 귀여운 표정이 매력적입니다.",
            //     detailEn: "A marine mammal that swims gracefully underwater, charming with its cute expressions.",
            //     detailJa: "水中で優雅に泳ぐ海洋哺乳類で、可愛い表情が魅力的です。",
            //     detailZh: "在水中优雅游泳的海洋哺乳动物，可爱的表情很有魅力。",
            //     image: "seal",
            //     stampImage: "seal_stamp",
            //     bingoNumber: 6,
            //     facility: sunpiazaAquarium
            // ),
            
            // // 토우베츠마린파크닉스
            // Animal(
            //     nameKo: "훔볼트펭귄",
            //     nameEn: "Humboldt Penguin",
            //     nameJa: "フンボルトペンギン",
            //     nameZh: "洪堡企鹅",
            //     detailKo: "남미 연안에 서식하는 중간 크기의 펭귄으로, 행진하는 모습이 사랑스럽습니다.",
            //     detailEn: "A medium-sized penguin from the South American coast, lovely when marching in groups.",
            //     detailJa: "南米沿岸に生息する中型のペンギンで、行進する姿が愛らしいです。",
            //     detailZh: "栖息在南美沿岸的中型企鹅，行进的样子很可爱。",
            //     image: "humboldt_penguin",
            //     stampImage: "humboldt_penguin_stamp",
            //     bingoNumber: 7,
            //     facility: marinenickAquarium
            // ),
            
            // // 사케노우라사토치토세수족관
            // Animal(
            //     nameKo: "연어",
            //     nameEn: "Salmon",
            //     nameJa: "サケ",
            //     nameZh: "鲑鱼",
            //     detailKo: "홋카이도의 대표적인 물고기로, 산란기에 강으로 돌아오는 회귀 본능이 유명합니다.",
            //     detailEn: "Hokkaido's representative fish, famous for its homing instinct to return to rivers during spawning season.",
            //     detailJa: "北海道の代表的な魚で、産卵期に川に戻ってくる回帰本能で有名です。",
            //     detailZh: "北海道的代表性鱼类，以产卵期回到河流的回归本能而闻名。",
            //     image: "salmon",
            //     stampImage: "salmon_stamp",
            //     bingoNumber: 8,
            //     facility: chitoseAquarium
            // ),
            
            // // AOAO SAPPORO
            // Animal(
            //     nameKo: "해파리",
            //     nameEn: "Jellyfish",
            //     nameJa: "クラゲ",
            //     nameZh: "水母",
            //     detailKo: "투명하고 신비로운 바다의 예술품으로, 우아하게 떠다니는 모습이 아름답습니다.",
            //     detailEn: "Transparent and mysterious sea creatures, beautiful as they float gracefully through the water.",
            //     detailJa: "透明で神秘的な海の芸術品で、優雅に漂う姿が美しいです。",
            //     detailZh: "透明而神秘的海洋艺术品，优雅漂浮的样子很美丽。",
            //     image: "jellyfish",
            //     stampImage: "jellyfish_stamp",
            //     bingoNumber: 9,
            //     facility: aoaoSapporo
            // ),
        ]
        
        // 일반 동물들 (빙고에 포함되지 않음)
        let regularAnimals: [Animal] = [
        ]
        
        return bingoAnimals + regularAnimals
    }
    
    /// 샘플 시설 데이터만 생성 (테스트용)
    static func createSampleFacilities() -> [Facility] {
        let animals = createSampleAnimals()
        let facilities = Set(animals.map { $0.facility })
        return Array(facilities)
    }
    
    /// 특정 타입의 샘플 데이터만 생성 (확장 가능)
    static func createSampleAnimals(for facilityType: FacilityType) -> [Animal] {
        let allAnimals = createSampleAnimals()
        
        return allAnimals.filter { $0.facility.type == facilityType }
    }
} 
