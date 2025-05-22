//
//  ContentView.swift
//  budgethink
//
//  Created by MacBook on 13/05/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView{
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house")
                }
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "list.bullet.clipboard")
                }
        }
    }
}

#Preview {
    HomeView()
}
