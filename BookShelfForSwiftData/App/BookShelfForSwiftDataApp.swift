//
//  BookShelfForSwiftDataApp.swift
//  BookShelfForSwiftData
//
//  Created by YoonieMac on 3/15/26.
//

import SwiftUI
import SwiftData

@main
struct BookShelfForSwiftDataApp: App {
    
    var body: some Scene {
        WindowGroup {
            BookMainView()
                .modelContainer(for: BookModel.self)
        }
    }
}
