//
//  AddBudgetView.swift
//  budgethink
//
//  Created by MacBook on 17/05/25.
//
import Foundation
import SwiftUI

struct AddEditBudgetView: View {
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @State private var inputBudget: String = ""
    
    var totalBudget: Int
    var dateMonth: Date
    
    func formatMonthYear(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }

    var body: some View {
        NavigationView {
            VStack{
                VStack(alignment: .leading){
                    Text("Set budget for \(formatMonthYear(from: dateMonth))")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .padding([.bottom], 4)
                    HStack {
                        Text("Rp")
                        TextField("200.000", text: $inputBudget)
                            .keyboardType(.numberPad)
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 5.0)
                                    .stroke(.gray, lineWidth: 1)
                            )
                        .navigationTitle("Set Budget")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarItems(
                            leading: Button("Cancel") {
                                dismiss()
                            },
                            trailing: Button("Save") {
                                
                            }
                        )
                    }
                    .padding([.bottom], 4)
                }
                .padding([.trailing, .leading], 20)
                .padding([.top, .bottom], 32)
                .background(
                    RoundedRectangle(cornerRadius: 15.0)
                        .stroke(.gray, lineWidth: 1)
                )
            }
            .padding([.bottom], 550)
            .padding([.trailing, .leading], 32)
        }
    }
}

#Preview {
    AddEditBudgetView(totalBudget: 0, dateMonth: Date())
}
