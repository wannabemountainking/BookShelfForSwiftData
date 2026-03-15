//
//  BookRowView.swift
//  BookShelfForSwiftData
//
//  Created by YoonieMac on 3/15/26.
//

import SwiftUI

struct BookRowView: View {
    
    let book: BookModel
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(book.title)
                        .strikethrough(book.status == .finished, color: .red)
                    Image(systemName: book.isFavorite ? "heart.fill" : "")
                        .foregroundStyle(.red)
                }
                .font(.title2.bold())
                Text(book.author)
                    .font(.title2)
                    .fontWeight(.light)
                    .foregroundStyle(.secondary)
                Text(book.rating.numberOfStars)
                    .font(.title2.bold())
                    .foregroundStyle(Color.yellow)
                Text(book.status.rawValue)
                    .font(.caption)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    let _ = BookModel.previewMockData
    let book = BookModel(title: "Clean Architecture", author: "로버트 마틴", status: .reading, rating: .two, startDate: BookModel.dateFormatter().date(from: "26년 01년 22일"))
    
    BookRowView(book: book)
}
