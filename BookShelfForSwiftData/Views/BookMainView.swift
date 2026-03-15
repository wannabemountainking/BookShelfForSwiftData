//
//  BookMainView.swift
//  BookShelfForSwiftData
//
//  Created by YoonieMac on 3/15/26.
//

import SwiftUI
import SwiftData

struct BookMainView: View {
    
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [BookModel]
    
    @State private var bookWillBeDeleted: BookModel?
    @State private var showAlert: Bool = false
    @State private var isNewBook: Bool = false
    
    
    @State private var selectedTab: ReadingStatus? = .wishlist
    @State private var favoriteOnly: Bool = false
    
    private var filteredBooks: [BookModel] {
        if let selectedTab {
            let readingStatusSelectedBooks = books.filter { $0.status == selectedTab }
            return readingStatusSelectedBooks.filter { favoriteOnly ? $0.isFavorite : true }
        } else {
            return books.filter { favoriteOnly ? $0.isFavorite : true }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                if books.isEmpty {
                    ContentUnavailableView(
                        "독서 정보를 입력하세요",
                        systemImage: "rectangle.and.pencil.and.ellipsis",
                        description:
                            Text("☝️ 위의 추가 버튼을 눌러서 독서 정보를 입력하세요")
                            .font(.headline)
                            .fontWeight(.light)
                    )
                } else {
                    Picker("독서 상황", selection: $selectedTab) {
                        Text("전체").tag(nil as ReadingStatus?)
                        Text("읽는 중").tag(ReadingStatus.reading)
                        Text("완독").tag(ReadingStatus.finished)
                        Text("찜").tag(ReadingStatus.wishlist)
                    }
                    .pickerStyle(.segmented)
                    
                    List {
                        ForEach(filteredBooks) { book in
                            NavigationLink {
                                // destinationView
                                AddAndUpdateView()
                            } label: {
                                BookRowView(book: book)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button("Delete", systemImage: "trash") {
                                            bookWillBeDeleted = book
                                            showAlert = true
                                        }
                                        .tint(.red)
                                    }
                                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                        Button(
                                            book.status.id,
                                            systemImage: book.status.iconName) {
                                                book.status.next()
                                            }
                                            .tint(book.status.iconColor)
                                    }
                            }
                        } //:LOOP
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.secondary.opacity(0.3))
                                .padding(.vertical, 5)
                        )
                    } //:LIST
                } //:CONDITION
            } //:VSTACK
            .navigationTitle("📚 내 서재")
            .sheet(isPresented: $isNewBook) {
                AddAndUpdateView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        //action
                        favoriteOnly.toggle()
                    } label: {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(
                                favoriteOnly ? Color.red.opacity(0.8) : Color.blue.opacity(0.3)
                            )
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        //action
                        isNewBook = true
                    } label: {
                        Image(systemName: "plus.app.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.green)
                    }

                }
                
            }
            .alert("삭제", isPresented: $showAlert) {
                //actionView
                Button("Delete", role: .destructive) {
                    guard let bookWillBeDeleted else {return}
                    modelContext.delete(bookWillBeDeleted)
                }
            } message: {
                Text("이 독서 정보를 정말로 삭제하시겠습니까?")
            }
            
        } //:NAVIGATION
    }//:body
}

#Preview("독서 목록 있음") {
    BookMainView()
        .modelContainer(BookModel.previewMockData)
}

#Preview("독서 목록 없음") {
    BookMainView()
}
