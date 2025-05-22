//
//  HistoryView.swift
//  budgethink
//
//  Created by MacBook on 15/05/25.
//

import SwiftUI
import SwiftData

struct ReportView: View {
    
    var currentKey: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Label("Needs", systemImage: "fork.knife.circle")
                    .font(.headline)
                    .padding(.horizontal)
                    .foregroundStyle(.indigo)
//                ForEach(allPlans) { item in
//                    HStack {
//                        Text(item.name)
//                        Spacer()
//                        Text("Rp\(Int(item.amount), format: .number)")
//                    }
//                    .padding(.horizontal)
//                    .padding(.vertical, 4)
//                }
//                .font(.callout)
                HStack {
                    Text("Subtotal")
                    Spacer()
                    Text("Rp\(Int(), format: .number)")
                }
                .bold()
                .padding()
            }
            Divider().padding()
            Group {
                Label("Wants", systemImage: "gift")
                    .font(.headline)
                    .padding(.horizontal)
                    .foregroundStyle(.indigo)
//                ForEach(allPlans) { item in
//                    HStack {
//                        Text(item.name)
//                        Spacer()
//                        Text("Rp\(Int(item.amount), format: .number)")
//                    }
//                    .padding(.horizontal)
//                    .padding(.vertical, 4)
//                }
//                .font(.callout)
                HStack {
                    Text("Subtotal")
                    Spacer()
                    Text("Rp\(Int(), format: .number)")
                }
                .bold()
                .padding()
            }
            Divider().padding()
            HStack {
                Text("Total")
                    .bold()
                Spacer()
                Text("Rp\(Int(), format: .number)")
                    .bold()
            }
            .padding()
            .foregroundStyle(.indigo)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ReportView(currentKey: Date())
}
