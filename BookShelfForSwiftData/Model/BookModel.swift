//
//  BookModel.swift
//  BookShelfForSwiftData
//
//  Created by YoonieMac on 3/15/26.
//

import SwiftUI
import SwiftData


enum ReadingStatus: String, Identifiable, Codable {
    case reading = "읽는 중"
    case finished = "완독"
    case wishlist = "찜"
    
    var id: String {
        switch self {
        case .reading: return "reading"
        case .finished: return "finished"
        case .wishlist: return "wishlist"
        }
    }
    
    var iconName: String {
        switch self {
        case .reading: return "book.fill"
        case .finished: return "checkmark.seal.fill"
        case .wishlist: return "heart.fill"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .reading: return Color.blue
        case .finished: return Color.green
        case .wishlist: return Color.red
        }
    }
    
    mutating func next() {
        switch self {
        case .reading: self = .finished
        case .finished: self = .wishlist
        case .wishlist: self = .reading
        }
    }
}

enum Rating: Int, Identifiable, Codable, CaseIterable {
    case zero = 0, one, two, three, four, five
    
    var id: Int {
        switch self {
        case .zero: return 0
        case .one: return 1
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        }
    }
    
    var numberOfStars: String {
        switch self {
        case .zero: return "☆☆☆☆☆"
        case .one: return "★☆☆☆☆"
        case .two: return "★★☆☆☆"
        case .three: return "★★★☆☆"
        case .four: return "★★★★☆"
        case .five: return "★★★★★"
        }
    }
}

@Model
final class BookModel {

    var title: String
    var author: String
    var status: ReadingStatus
    var rating: Rating
    var isFavorite: Bool
    var startDate: Date?
    var memo: String
    
    init(title: String, author: String, status: ReadingStatus = .reading, rating: Rating = Rating.zero, isFavorite: Bool = false, startDate: Date? = nil, memo: String = "") {
        self.title = title
        self.author = author
        self.status = status
        self.rating = rating
        self.isFavorite = isFavorite
        self.startDate = startDate
        self.memo = memo
    }
}

@MainActor
extension BookModel {
    
    static var previewMockData: ModelContainer {
        let container: ModelContainer
        
        do {
            container = try ModelContainer(for: BookModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        } catch {
            fatalError("Error on InMemoryOnlyData setting: \(error)")
        }
        
        let mockBooks = [
            BookModel(title: "클린 코드", author: "로버트 마틴", status: .reading, rating: .five, isFavorite: true),
            BookModel(title: "Swift 프로그래밍", author: "애플", status: .finished, rating: .three),
            BookModel(title: "리팩터링", author: "마틴 파울러", status: .wishlist, rating: .zero),
            BookModel(title: "객체 지향의 사실과 오해", author: "조영호", status: .finished, rating: .four, isFavorite: true),
            BookModel(title: "Clean Architecture", author: "로버트 마틴", status: .reading, rating: .two, startDate: dateFormatter().date(from: "26년 01년 22일"))
        ]
        
        for mockBook in mockBooks {
            container.mainContext.insert(mockBook)
        }
        
        try? container.mainContext.save() // preview는 앱 생명주기가 아예 없어서 autosave가 트리거 되는 이벤트가 없어서 autosave가 안될 가능성도 높으므로 강제로 시키는 것임.autosave가 실행되는 환경 -> 앱이 백그라운드로 갈 때, UI 이벤트가 끝날 때 RunLoop 사이클이 돌 때
        return container
    }
    
    static func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일"
        return formatter
    }
    
    func formattedStartDate() -> String {
        guard let startingDate = self.startDate else { return "날짜 미정" }
        return BookModel.dateFormatter().string(from: startingDate)
    }
}


