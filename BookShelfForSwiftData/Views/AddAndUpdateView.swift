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
    
    @State private var hasStartDate: Bool = false
    
    // MARK: - Properties
    var book: BookModel?
    var isNewBook: Bool { self.book == nil }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                Section("📕 책 정보") {
                    Label {
                        //titleView
                        TextField("제목 입력", text: $title)
                            .textFieldStyle(.roundedBorder)
                    } icon: {
                        Image(systemName: "book.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    
                    Label {
                        // titleView
                        TextField("저자 입력", text: $author)
                            .textFieldStyle(.roundedBorder)
                    } icon: {
                        Image(systemName: "applepencil.hover")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
                .listRowSeparator(.hidden)
                
                Section("📊 독서 상태") {
                    Picker("", selection: $readingStatus) {
                        Text("읽는 중").tag(ReadingStatus.reading)
                        Text("완독").tag(ReadingStatus.finished)
                        Text("찜").tag(ReadingStatus.wishlist)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("⭐️ 별점") {
                    HStack(spacing: 2) {
                        ForEach(Array(Rating.allCases.dropFirst())) { ratingStar in
                            Button {
                                //action
                                self.rating = ratingStar
                            } label: {
                                Text(self.rating.rawValue < ratingStar.rawValue ? "☆" : "★")
                                    .font(.title2.bold())
                                    .foregroundStyle(.yellow)
                            }
                            .padding(.horizontal, 3)
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                Toggle(isOn: $hasStartDate) {
                    Text("📅 읽기 시작일")
                }
                
                if hasStartDate {
                    DatePicker(
                        "",
                        selection: $startDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                }
                
                Section("💬 한줄평") {
                    TextField("한줄평을 입력하세요", text: $memo, axis: .vertical)
                }
                
                Section {
                    HStack(spacing: 25) {
                        Button {
                            //action
                            if isNewBook {
                                let newBook = BookModel(
                                    title: title,
                                    author: author,
                                    status: readingStatus,
                                    rating: rating,
                                    startDate: startDate,
                                    memo: memo
                                )
                                modelContext.insert(newBook)
                            } else {
                                book?.title = self.title
                                book?.author = self.author
                                book?.status = self.readingStatus
                                book?.rating = self.rating
                                book?.startDate = hasStartDate ? self.startDate : nil
                                book?.memo = self.memo
                            }
                            dismiss()
                        } label: {
                            Text("SAVE")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(height: 35)
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.8))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        Button {
                            //action
                            dismiss()
                        } label: {
                            Text("CANCEL")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(height: 35)
                                .frame(maxWidth: .infinity)
                                .background(Color.red.opacity(0.8))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                
            } //:LIST
            .navigationTitle(book == nil ? "독서 정보 추가" : "독서 정보 수정")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                if !isNewBook {
                    self.title = book?.title ?? ""
                    self.author = book?.author ?? ""
                    self.readingStatus = book?.status ?? .reading
                    self.rating = book?.rating ?? .zero
                    self.startDate = book?.startDate ?? Date()
                    self.hasStartDate = book?.startDate != nil
                    self.memo = book?.memo ?? ""
                }
            }
        } //:NAVIGATION
    }//:body
}

#Preview("book 있음") {
    
    let _ = BookModel.previewContainer
    let theBook = BookModel(title: "Clean Architecture", author: "로버트 마틴", status: .reading, rating: .two, startDate: BookModel.dateFormatter().date(from: "26년 01년 22일"))
    return AddAndUpdateView(book: theBook)
}

#Preview("book 없음") {
    NavigationStack {
        AddAndUpdateView()
    }
    .modelContainer(BookModel.previewContainer)
}
