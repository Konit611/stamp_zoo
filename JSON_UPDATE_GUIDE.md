# JSON 기반 동적 데이터 업데이트 시스템 - 개발자 가이드

## 📋 개요

기존의 하드코딩된 샘플 데이터 시스템을 JSON 파일 기반의 동적 업데이트 시스템으로 변경했습니다. 개발자가 직접 JSON 파일을 관리하여 앱의 동물원 데이터를 업데이트할 수 있습니다.

## 🔧 변경된 구조

### 1. 새로 추가된 파일들

#### JSON 모델 및 서비스
- `stamp_zoo/Model/JSON/JSONDataModels.swift` - JSON 데이터 모델 정의
- `stamp_zoo/Core/Service/JSONDataService.swift` - JSON 파일 관리 서비스

#### JSON 데이터 파일 (Resources 폴더)
- `stamp_zoo/Resources/zoo_data_2025_01_05.json` - 초기 데이터
- `stamp_zoo/Resources/zoo_data_2025_01_06.json` - 업데이트 예시 데이터

### 2. 수정된 파일들
- `stamp_zoo/App/stamp_zooApp.swift` - JSONDataService로 변경

## 🚀 사용 방법

### 데이터 업데이트 과정

1. **새로운 JSON 파일 생성**
   ```
   zoo_data_YYYY_MM_DD.json
   ```
   예: `zoo_data_2025_01_07.json`

2. **JSON 파일 형식**
   ```json
   {
     "metadata": {
       "version": "1.0.0",
       "last_updated": "2025-01-07",
       "description": "설명",
       "data_count": 데이터개수
     },
     "facilities": [...],
     "animals": [...]
   }
   ```

3. **Xcode 프로젝트에 추가**
   - Xcode에서 `stamp_zoo/Resources/` 폴더에 JSON 파일 추가
   - Bundle resources에 포함되도록 설정

4. **자동 업데이트**
   - 앱 시작 시 자동으로 최신 JSON 파일 감지
   - 날짜가 더 최신인 파일이 있으면 자동 업데이트

## 📁 JSON 파일 구조

### Facility (시설) 필드
```json
{
  "id": "고유ID",
  "facility_id": "시설ID",
  "name_ko": "한국어명",
  "name_en": "영어명", 
  "name_ja": "일본어명",
  "name_zh": "중국어명",
  "type": "zoo" 또는 "aquarium",
  "location_ko": "위치(한국어)",
  "location_en": "위치(영어)",
  "location_ja": "위치(일본어)",
  "location_zh": "위치(중국어)",
  "image": "시설이미지명",
  "logo_image": "로고이미지명",
  "map_image": "지도이미지명",
  "map_link": "구글맵링크",
  "detail_ko": "상세설명(한국어)",
  "detail_en": "상세설명(영어)",
  "detail_ja": "상세설명(일본어)",
  "detail_zh": "상세설명(중국어)",
  "latitude": 위도,
  "longitude": 경도,
  "validation_radius": QR스캔유효범위
}
```

### Animal (동물) 필드
```json
{
  "id": "고유ID",
  "name_ko": "한국어명",
  "name_en": "영어명",
  "name_ja": "일본어명", 
  "name_zh": "중국어명",
  "detail_ko": "설명(한국어)",
  "detail_en": "설명(영어)",
  "detail_ja": "설명(일본어)",
  "detail_zh": "설명(중국어)",
  "image": "동물이미지명",
  "stamp_image": "스탬프이미지명",
  "bingo_number": 빙고번호(1-9),
  "facility_id": "소속시설ID"
}
```

## ⚠️ 주의사항

1. **파일명 규칙 준수**
   - 반드시 `zoo_data_YYYY_MM_DD.json` 형식
   - 날짜는 실제 업데이트 날짜 사용

2. **이미지 리소스**
   - JSON에서 참조하는 이미지는 Assets.xcassets에 존재해야 함
   - 이미지명은 확장자 없이 입력

3. **GPS 좌표**
   - 정확한 위도/경도 입력 필요
   - QR 스캔 위치 검증에 사용됨

4. **빙고 번호**
   - 1-9 사이의 값
   - 중복되면 안 됨

## 🔄 폴백 시스템

### 안전성 보장
- JSON 로드 실패 시 기본 샘플 데이터 자동 로드
- 앱 안정성 보장
- 개발 중 실수로 잘못된 JSON을 추가해도 앱이 정상 동작

## 🎯 확장 가능성

1. **원격 업데이트**
   - 서버에서 JSON 파일 다운로드
   - 네트워크 기반 자동 업데이트

2. **버전 관리**
   - JSON 스키마 버전 관리
   - 호환성 체크

3. **부분 업데이트**
   - 전체가 아닌 변경된 부분만 업데이트
   - 효율적인 데이터 동기화

## 💻 개발자 워크플로우

1. **데이터 수정이 필요할 때**
   ```bash
   # 1. 새로운 JSON 파일 생성
   cp zoo_data_2025_01_05.json zoo_data_2025_01_07.json
   
   # 2. 내용 수정
   # 3. Xcode 프로젝트에 추가
   # 4. 빌드 후 앱에서 자동 감지
   ```

2. **테스트 방법**
   - 시뮬레이터에서 앱 재시작
   - 콘솔 로그로 JSON 로드 상태 확인
   - 새로운 데이터가 반영되는지 확인

3. **배포 시**
   - 새로운 JSON 파일이 Bundle에 포함되어 있는지 확인
   - 기존 사용자도 앱 업데이트 시 새 데이터로 자동 전환

이제 개발자가 JSON 파일만 관리하면 앱의 동물과 시설 데이터를 쉽게 업데이트할 수 있습니다!
