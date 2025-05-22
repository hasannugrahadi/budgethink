//
//  PlanRowView.swift
//  budgethink
//
//  Created by MacBook on 19/05/25.
//

import SwiftUI

struct PlanRowView: View {
    var planList: Plan
    var onEdit: (Plan) -> Void
    var onDelete: (Plan) -> Void

    private func determineColorPriority(priority: Priority) -> Color {
        switch priority {
        case .Low: return .green
        case .Medium: return .yellow
        case .High: return .red
        }
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 5) {
                Text(planList.title)
                    .bold()
                    .font(.caption)
                Text("Rp\(planList.price.formatted()),-")
                    .font(.caption)
                    .bold()
                    .foregroundStyle(.gray)
                HStack {
                    Text("\(planList.priority.rawValue) priority")
                        .font(.caption)
                    Image(systemName: "star.circle.fill")
                        .foregroundColor(determineColorPriority(priority: planList.priority))
                }
            }
            Spacer()
            Menu {
                Button("Edit") {
                    onEdit(planList)
                }
                Button("Delete", role: .destructive) {
                    onDelete(planList)
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .foregroundColor(.indigo)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15.0)
                .stroke(.indigo, lineWidth: 1)
        )
    }
}

