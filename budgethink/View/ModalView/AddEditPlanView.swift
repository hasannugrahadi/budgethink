//
//  AddPlanView.swift
//  budgethink
//
//  Created by MacBook on 15/05/25.
//

import SwiftUI
import SwiftData

struct AddEditPlanView: View {
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @State private var item: String = ""
    @State private var price: String = ""
    @State private var priority: Priority = .Medium
    @State private var showAlert = false
    
    private func formatCurrency(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.numberStyle = .currency
        formatter.currencySymbol = "Rp"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "Rp 0"
    }
    
    func onSave(name: String, price: Int, priority: Priority) {
        guard let budget = try? context.fetch(FetchDescriptor<Budget>()).first(where: {
            Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .month)
        }) else {
            return
        }

        var canSave = false

        switch category {
        case .Needs:
            if budget.currentNeedsBudget >= price {
                budget.currentNeedsBudget -= price
                canSave = true
            } else if budget.currentNeedsBudget + budget.currentSavingsBudget >= price {
                let extraNeeded = price - budget.currentNeedsBudget
                budget.currentNeedsBudget = 0
                budget.currentSavingsBudget -= extraNeeded
                canSave = true
            }
        case .Wants:
            if budget.currentWantsBudget >= price {
                budget.currentWantsBudget -= price
                canSave = true
            } else if budget.currentWantsBudget + budget.currentSavingsBudget >= price {
                let extraNeeded = price - budget.currentWantsBudget
                budget.currentWantsBudget = 0
                budget.currentSavingsBudget -= extraNeeded
                canSave = true
            }
        }

        if canSave {
            let newPlan = Plan(
                name: UUID().uuidString,
                title: name,
                price: price,
                priority: priority,
                category: category,
                date: Date()
            )
            context.insert(newPlan)
            try? context.save()
            dismiss()
        } else {
            showAlert = true
        }
    }
    
    var maxAllocation: Int
    let category: Category
    
    var body: some View {
        NavigationView {
            Form {
            
            }
            .navigationTitle("Add \(category)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    guard let priceItem = Int(price), !item.isEmpty else {
                        showAlert = true
                        return
                    }
                    if priceItem > maxAllocation {
                        showAlert = true
                    }
                    onSave(name: item, price: priceItem, priority: priority)
                }
            )
        }
    }
}

