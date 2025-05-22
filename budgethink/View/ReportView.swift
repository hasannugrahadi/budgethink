//
//  HistoryView.swift
//  budgethink
//
//  Created by MacBook on 15/05/25.
//

import SwiftUI

struct ReportView: View {
    @StateObject private var viewModel = ReportViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            // Header
            HStack {
                Text("Report")
                    .font(.title)
                    .bold()
                    .foregroundColor(.purple)
                
                Spacer()
                
                // DatePicker untuk memilih bulan
                DatePicker(
                    "",
                    selection: $viewModel.selectedDate,
                    displayedComponents: [.date]
                )
                .labelsHidden()
                .datePickerStyle(.compact)
                .frame(maxWidth: 120)
            }
            .padding()
            
            // Needs Section
            Group {
                Text("Needs")
                    .font(.headline)
                    .padding(.horizontal)
                Divider()
                
                ForEach(viewModel.needs) { item in
                    ReportRow(item: item)
                }
                
                HStack {
                    Text("Subtotal")
                    Spacer()
                    Text("Rp\(Int(viewModel.totalNeeds), format: .number)")
                        .bold()
                }
                .padding()
            }
            
            // Wants Section
            Group {
                Text("Wants")
                    .font(.headline)
                    .padding(.horizontal)
                Divider()
                
                ForEach(viewModel.wants) { item in
                    ReportRow(item: item)
                }
                
                HStack {
                    Text("Subtotal")
                    Spacer()
                    Text("Rp\(Int(viewModel.totalWants), format: .number)")
                        .bold()
                }
                .padding()
            }
            
            // Total
            Divider()
            HStack {
                Text("Total")
                    .bold()
                Spacer()
                Text("Rp\(Int(viewModel.total), format: .number)")
                    .bold()
            }
            .padding()
            
            Spacer()
            
        }
    }
}

// Row untuk setiap item pengeluaran
struct ReportRow: View {
    let item: ReportItem
    
    var body: some View {
        HStack {
            Text(item.name)
            Spacer()
            Text("Rp\(Int(item.amount), format: .number)")
        }
//        .padding()
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}


import Foundation

enum Kategori: String {
    case needs = "Needs"
    case wants = "Wants"
}

struct ReportItem: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let kategori: Kategori
}

class ReportViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()

    // Format tampilan bulan seperti "Jan 2025"
    var formattedMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: selectedDate)
    }

    // Contoh data statis
    @Published var items: [ReportItem] = [
        ReportItem(name: "Lorem", amount: 25000, kategori: .needs),
        ReportItem(name: "Lorem", amount: 25000, kategori: .needs),
        ReportItem(name: "Lorem", amount: 25000, kategori: .needs),
        ReportItem(name: "Lorem", amount: 25000, kategori: .wants),
        ReportItem(name: "Lorem", amount: 25000, kategori: .wants),
        ReportItem(name: "Lorem", amount: 25000, kategori: .wants)
    ]
    
    var needs: [ReportItem] {
        items.filter { $0.kategori == .needs }
    }

    var wants: [ReportItem] {
        items.filter { $0.kategori == .wants }
    }

    var totalNeeds: Double {
        needs.reduce(0) { $0 + $1.amount }
    }

    var totalWants: Double {
        wants.reduce(0) { $0 + $1.amount }
    }

    var total: Double {
        totalNeeds + totalWants
    }
}

#Preview {
    ReportView()
}
