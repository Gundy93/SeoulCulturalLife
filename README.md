# 🎟️ 서울 문화생활 탁

Gundy의 서울시 문화행사 정보 앱입니다. 서울문화포털에서 제공하는 문화행사 정보 오픈 API를 통해 문화 행사 정보를 테이블 형태로 제공하고 원하는 정보를 스크랩하여 CoreData에 저장하는 앱입니다.

### 주요 기술 스택

**MVVM, Clean Architecture, Core Data, Async/Await, URLSession, Delegate, NotificationCenter**

### 앱의 목표

다양한 조건으로 필터링하여 행사 정보를 검색하고 원하는 행사를 스크랩한다.

## 📖 목차

1. [팀 소개](#-팀-소개)
2. [Diagram](#-class-diagram)
3. [폴더 구조](#-file-tree)
4. [타임라인](#-타임라인)
5. [실행 화면](#-실행-화면)
6. [트러블 슈팅 및 고민한 부분](#-트러블-슈팅-및-고민한-부분)
7. [참고 자료](#-참고-자료)

## 🌱 팀 소개

|[Gundy](https://github.com/Gundy93)|
|:-:|
|<img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src= "https://avatars.githubusercontent.com/u/106914201?v=4">|
|'오늘 뭐 하지?' 할 땐 바로 이 앱!|

## 📊 Class Diagram

### Simple

![simple](https://github.com/Gundy93/SeoulCulturalLife/assets/106914201/c325a7c7-98be-4188-a5d5-1a1b5e974d9a)

### Detail

![Detail](https://github.com/Gundy93/SeoulCulturalLife/assets/106914201/5c0949bc-924b-4983-9cea-460ecd963dcd)

## 🗂 File Tree

```
SeoulCulturalLife
├── AppDelegate
├── SceneDelegate
├── Resource
│   └── Info.plist
├── Utility
│   ├── Extensions
│   │   ├── DateFormatter+
│   │   ├── UIButton+
│   │   ├── UIImage+
│   │   ├── UILabel+
│   │   └── UIStackView+
│   └── GlobalConstant
├── Entities
│   ├── Category
│   ├── Gu
│   └── Event
├── UseCases
│   ├── UseCase
│   ├── UseCaseDelegate
│   ├── ListUseCase
│   └── ScrapUseCase
├── InterfaceAdapters
│   ├── ViewModel
│   │   ├── ViewModel
│   │   ├── ListViewModel
│   │   └── ScrapViewModel
│   ├── DataAdapter
│   │   ├── DataAdapter
│   │   ├── JSONDataAdapter
│   │   └── CoreDataAdapter
│   ├── DTO
│   │   ├── EventDTO
│   │   └── EventResponseDTO
│   └── CoreData
│       └── SeoulCulturalLife.xcdatamodeld
│           └── SeoulCulturalLife.xcdatamodel
│               └── contents
└── FrameworksAndDrivers
    ├── ViewController
    │   ├── EventsViewController
    │   ├── ListViewController
    │   ├── ScrapViewController
    │   ├── FilterViewController
    │   ├── DetailViewController
    │   └── EventsTabBarController
    ├── View
    │   ├── ListCell
    │   └── ScrapCell
    ├── NetworkManager
    │   ├── APIProvider
    │   ├── EventAPIProvider
    │   ├── NetworkingError
    │   ├── DataFetcher
    │   └── NetworkManager
    └── CoreDataManager
        ├── EntityManager
        ├── EventEntityManager
        └── CoreDataManager
```

## 📆 타임라인

**개발 기간** 2023년 9월 25일 ~ 2023년 10월 4일

| 날짜 | 작업내용 |
|:--:|:--:|
| 9월 25일 | Entities, UseCases 작업 |
| 9월 26일 | ListViewModel 작업 |
| 9월 27일 | ListViewController, FilterViewController 작업 |
| 9월 28일 | 필터의 UIMenu 작업 |
| 9월 30일 | NetworkManager 작업 |
| 10월 1일 | DetailViewController 작업 |
| 10월 2일 | ScrapViewModel, ScrapViewController 작업 |
| 10월 3일 | CoreDataManager, EventsTabBarController 작업 |
| 10월 4일 | 컨벤션 정리 및 리드미 작성 |

## 📱 실행 화면

|리스트|필터|리프레시|
|:--:|:--:|:--:|
|![Simulator Screen Recording - iPhone 15 Pro - 2023-10-04 at 12 45 02](https://github.com/Gundy93/SeoulCulturalLife/assets/106914201/fce98653-3345-41ba-b1be-2d7e99ae939c)|![Simulator Screen Recording - iPhone 15 Pro - 2023-10-04 at 12 45 52](https://github.com/Gundy93/SeoulCulturalLife/assets/106914201/5a1e98b8-6a05-4db0-9374-80dba73a6c81)|![Simulator Screen Recording - iPhone 15 Pro - 2023-10-04 at 12 46 07](https://github.com/Gundy93/SeoulCulturalLife/assets/106914201/52165fc8-af0f-4b60-ae64-48487c647c54)|

|스크랩|언스크랩|하이퍼링크|
|:--:|:--:|:--:|
|![Simulator Screen Recording - iPhone 15 Pro - 2023-10-04 at 12 47 07](https://github.com/Gundy93/SeoulCulturalLife/assets/106914201/d4263702-864c-40e9-8f39-8cd7afd807a5)|![Simulator Screen Recording - iPhone 15 Pro - 2023-10-04 at 12 47 34](https://github.com/Gundy93/SeoulCulturalLife/assets/106914201/932df8cb-8a3b-4ef1-8bfe-0d95c8164e33)|![Simulator Screen Recording - iPhone 15 Pro - 2023-10-04 at 12 48 04](https://github.com/Gundy93/SeoulCulturalLife/assets/106914201/cf58ed92-a0f4-499d-8a4e-91b4e1a23ed4)|

## 🎳 트러블 슈팅 및 고민한 부분

### 여러 뷰컨트롤러에서 사용할 수 있는 뷰모델

조건 설정을 위한 필터 화면과 검색결과를 조회하는 화면간의 데이터 전달을 위한 방법으로 뷰모델을 공유하는 방법을 생각했습니다. 이 때 뷰와 모델간의 데이터 바인딩을 어떻게 해야 좋을지 고민이었습니다. Delegate 패턴으로 바인딩 할 경우 뷰와 뷰모델의 1:1의 연결만이 가능하므로 적절하지 않았습니다. 또한 클로저로 주고 받는 방법도 배열 등을 통해 뷰 별로 원하는 리액션을 추가한다면 구현할 수도 있겠으나 잘 관리하기도 어렵고 비효율적이라는 생각이 들었습니다.

이를 해결하기 위해 Notification 방식을 사용하기로 했습니다. 1:1로 연결될 필요가 없기 때문에 여러 뷰가 뷰모델을 공유할 수 있다고 생각했습니다.

### 공통 특성을 묶어 중복 코드 제거하기

UseCase, ViewModel, DataAdapter, EventsViewController, EntityManager 등은 공통 특성을 정의하거나 요구하기 위해 작성한 프로토콜 및 추상화 클래스입니다. 처음에는 모두 프로토콜을 사용하고자 마음먹었기 때문에 Class Diagram 또한 프로토콜과 준수타입으로 구분해 작성했었습니다.

하지만 실제로 코드를 작성해나가다보니 프로토콜의 기본구현만으로는 중복 코드를 적절히 제거하지 못하는 경우가 발생하는 것을 깨달았습니다. 클래스의 상속체계에서는 재정의와 super 호출을 통해 기존 정의 부분을 그대로 사용하면서 추가 코드를 작성할 수 있었는데, 프로토콜 기본 구현에서는 그런 방법을 사용할 수가 없었습니다. 성능적으로는 클래스보다 구조체를 택함이 유효하겠지만 결국 코드는 사람이 읽는 것이기 때문에 불필요한 중복 코드를 제거해 전체 코드의 길이가 줄어드는 것이 가독성에 좋다고 생각했습니다. 때문에 그러한 경우 ViewModel과 같이 추상화 클래스를 정의하는 것으로 구조를 변경하였습니다.

### UINavigationController vs UITabBarController

목록 화면과 스크랩 화면 모두 UINavigationController와 UITabBarController를 함께 사용하는 계층 구조를 지녔습니다. 여기서 중요한 점은 '어떤 컨트롤러가 계층 구조의 상단에 위치해야 하는가'였습니다. 처음에는 탭바 컨트롤러에 각 뷰컨트롤러를 갖고 있는 네비게이션 컨트롤러들을 넣어주었습니다. 하지만 반대로 최상위에 네비게이션 컨트롤러가 있고 그 아래에 탭바와 뷰컨트롤러들이 있다면 더욱 효율적인 구조가 됨을 깨달아 수정하였습니다.

그렇다고 항상 네비게이션 컨트롤러가 최상위여야 하는가? 이 의문을 더욱 고민해보고 내린 결론은 '구조에 따라 다를 것이다' 입니다. 이번 프로젝트에서는 모든 뷰컨트롤러가 네비게이션 컨트롤러를 필요로 했고, 네비게이션 컨트롤러에 push하는 뷰컨트롤러가 같고, 탭바가 사라지길 원했기 때문에 네비게이션 컨트롤러가 최상위에 위치한 것이 적절했습니다. 하지만 push하여 들어가더라도 탭바가 유지되길 원한다거나, 탭바의 아이템 중 네비게이션 컨트롤러가 필요하지 않은 뷰컨트롤러들이 있다거나 하는 경우라면 탭바가 최상단에 위치할 수도 있겠다는 생각을 했습니다.

## 📚 참고 자료

### WWDC

[**Meet async/await in Swift**](https://developer.apple.com/videos/play/wwdc2021/10132/)

### Apple Developer Documentation

[**Concurrency**](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency)

---
[⬆️ 맨 위로 이동하기](#-서울-문화생활-탁)
