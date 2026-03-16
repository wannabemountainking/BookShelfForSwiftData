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
                Text(book.title)
                    .strikethrough(book.status == .finished, color: .red)
                    .font(.title2.bold())
                    .foregroundStyle(book.status == .finished ? .gray : .black)
                Text(book.author)
                    .font(.title2)
                    .fontWeight(.light)
                    .foregroundStyle(.secondary)
                Text(book.rating.numberOfStars)
                    .font(.title2.bold())
                    .foregroundStyle(Color.yellow)
                HStack(spacing: 30) {
                    Text(book.status.rawValue)
                        .font(.caption)
                    Image(systemName: "heart.fill")
                        .opacity(book.isFavorite ? 1 : 0)
                        .foregroundStyle(.red)
                        .font(.headline)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    let _ = BookModel.previewContainer
    let book = BookModel(title: "Clean Architecture", author: "로버트 마틴", status: .reading, rating: .two, isFavorite: false, startDate: BookModel.dateFormatter().date(from: "26년 01년 22일"))
    
    BookRowView(book: book)
}
