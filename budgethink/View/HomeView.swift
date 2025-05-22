//
//  ContentView.swift
//  budgethink
//
//  Created by MacBook on 13/05/25.
//

import SwiftUI

struct HomeView: View {
    
    @State private var selectedTab = 0
    @State private var isShowingDatePicker = false
    @State private var isFocus = false
    @State private var selectedDate: Date = Date()
    
    func getCurrentKey(monthYear : Date) -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "MMMM yyyy"
        let dateString = formatter.string(from: monthYear)
        return formatter.date(from: dateString) ?? monthYear
    }
    
    var body: some View {
        HStack{
            Text({selectedTab == 0 ? "Dashboard" : "Report"}())
                .font(.title2)
                .bold()
                .foregroundStyle(.indigo)
            Spacer()
            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .labelsHidden()
            .datePickerStyle(.compact)
        }
        .padding(.horizontal)
        TabView(selection: $selectedTab){
            DashboardView(currentKey: getCurrentKey(monthYear: selectedDate))
            .tabItem {
                Label("Dashboard", systemImage: "house")
            }
            .tag(0)
            ReportView(currentKey: getCurrentKey(monthYear: selectedDate))
            .tabItem {
                Label("Report", systemImage: "list.bullet.clipboard")
            }
            .tag(1)
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [Plan.self, Budget.self])
}
