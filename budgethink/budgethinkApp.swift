//
//  budgethinkApp.swift
//  budgethink
//
//  Created by MacBook on 13/05/25.
//

import SwiftUI
import SwiftData

@main
struct budgethinkApp: App {
    var body: some Scene {
        WindowGroup() {
            MainView()
        }
        .modelContainer(for: [Plan.self])
    }
}
