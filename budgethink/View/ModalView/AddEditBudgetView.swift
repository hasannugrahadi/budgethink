//
//  AddBudgetView.swift
//  budgethink
//
//  Created by MacBook on 17/05/25.
//
import SwiftData
import SwiftUI

struct AddEditBudgetView: View {
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @State private var inputBudget: String = ""
    
    @Query(sort: \Budget.date, order: .forward) private var allBudgets: [Budget]
    
    var totalBudget: Int?
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
                    Text("\(totalBudget != nil ? "Update" : "Set" ) budget for \(formatMonthYear(from: dateMonth))")
                        .font(.caption)
                        .padding([.bottom], 4)
                    HStack {
                        Text("Rp")
                        TextField("Minimal 100000", text: $inputBudget)
                            .keyboardType(.numberPad)
                            .padding(6)
                            .font(.callout)
                            .background(
                                RoundedRectangle(cornerRadius: 5.0)
                                    .stroke(.gray, lineWidth: 1)
                            )
                        .navigationTitle("\(totalBudget != nil ? "Update" : "Set") Budget")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarItems(
                            leading: Button("Cancel") {
                                dismiss()
                            },
                            trailing: Button("Save") {
                                guard let budgetAmount = Int(inputBudget), budgetAmount >= 100_000 else { return }

                                let existingBudget = allBudgets.first { Calendar.current.isDate($0.date, equalTo: dateMonth, toGranularity: .month) }

                                if let budget = existingBudget {
                                    budget.totalBudget = budgetAmount
                                    budget.currentNeedsBudget = budgetAmount * 50 / 100
                                    budget.currentWantsBudget = budgetAmount * 30 / 100
                                    budget.currentSavingsBudget = budgetAmount * 20 / 100
                                } else {
                                    let newBudget = Budget(
                                        monthYear: dateMonth,
                                        totalBudget: budgetAmount,
                                        currentNeedsBudget: budgetAmount * 50 / 100,
                                        currentWantsBudget: budgetAmount * 30 / 100,
                                        currentSavingsBudget: budgetAmount * 20 / 100
                                    )
                                    context.insert(newBudget)
                                }
                                try? context.save()
                                dismiss()
                                
                            }
                                .disabled(Int(inputBudget) ?? 0 < 99999)
                        )
                    }
                    .padding([.bottom], 4)
                    if totalBudget != nil {
                        Text("Current budget: \(String(describing: totalBudget)))")
                            .font(.caption)
                    }
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
