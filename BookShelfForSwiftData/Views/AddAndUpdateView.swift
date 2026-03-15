//
//  AddAndUpdateView.swift
//  BookShelfForSwiftData
//
//  Created by YoonieMac on 3/15/26.
//

import SwiftUI
import SwiftData

struct AddAndUpdateView: View {
    
    // MARK: - Properties(@Environment)
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Properties(@State)
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var readingStatus: ReadingStatus = .reading
    @State private var rating: Rating = .zero
    @State private var startDate: Date = .now
    @State private var memo: String = ""
    
    // MARK: - Properties
    var book: BookModel?
    var isNewBook: Bool { book == nil as BookModel? }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                Section("책 정보") {
                    Label {
                        //titleView
                        TextField("제목 입력", text: $title)
                            .textFieldStyle(.roundedBorder)
                    } icon: {
                        Image(systemName: "book.fill")
                            .font(.title2)
                    }
                    
                    Label {
                        // titleView
                        TextField("저자 입력", text: $author)
                    } icon: {
                        Image(systemName: "applepencil.hover")
                    }


                }
            } //:LIST
            .navigationTitle(isNewBook ? "독서 정보 추가" : "독서 정보 수정")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                
            }
        } //:NAVIGATION
    }//:body
}

#Preview("book 있음") {
    
    let _ = BookModel.previewMockData
    let theBook = BookModel(title: "Clean Architecture", author: "로버트 마틴", status: .reading, rating: .two, startDate: BookModel.dateFormatter().date(from: "26년 01년 22일"))
    return AddAndUpdateView(book: theBook)
}

#Preview("book 없음") {
    NavigationStack {
        AddAndUpdateView()
    }
    .modelContainer(BookModel.previewMockData)
}
