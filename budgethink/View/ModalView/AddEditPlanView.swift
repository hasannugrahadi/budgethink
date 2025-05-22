//
//  AddPlanView.swift
//  budgethink
//
//  Created by MacBook on 15/05/25.
//

import SwiftUI
import SwiftData

struct AddEditPlanView: View {
    
    var maxAllocation: Int
    let category: Category
    var editingPlan: Plan? = nil
    let priorityOption = ["Low", "Medium", "High"]
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @State private var item: String = ""
    @State private var priceText: String = ""
    @State private var priority: String = "Low"
    @State private var showAlert = false
    
    init(maxAllocation: Int, category: Category, editingPlan: Plan? = nil) {
        self.maxAllocation = maxAllocation
        self.category = category
        self.editingPlan = editingPlan
        _item = State(initialValue: editingPlan?.title ?? "")
        _priceText = State(initialValue: String(editingPlan?.price ?? 0))
        _priority = State(initialValue: editingPlan?.priority.rawValue ?? "Low")
    }
    
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

        let delta = price - (editingPlan?.price ?? 0)
        var canSave = false

        switch category {
        case .Needs:
            let totalAvailable = budget.currentNeedsBudget + budget.currentSavingsBudget + (editingPlan?.price ?? 0)
            if totalAvailable >= price {
                if price <= budget.currentNeedsBudget + (editingPlan?.price ?? 0) {
                    budget.currentNeedsBudget -= delta
                } else {
                    let fromSaving = delta - budget.currentNeedsBudget
                    budget.currentNeedsBudget = 0
                    budget.currentSavingsBudget -= fromSaving
                }
                canSave = true
            }
        case .Wants:
            let totalAvailable = budget.currentWantsBudget + budget.currentSavingsBudget + (editingPlan?.price ?? 0)
            if totalAvailable >= price {
                if price <= budget.currentWantsBudget + (editingPlan?.price ?? 0) {
                    budget.currentWantsBudget -= delta
                } else {
                    let fromSaving = delta - budget.currentWantsBudget
                    budget.currentWantsBudget = 0
                    budget.currentSavingsBudget -= fromSaving
                }
                canSave = true
            }
        }

        if canSave {
            if let plan = editingPlan {
                plan.title = name
                plan.price = price
                plan.priority = priority
            } else {
                let newPlan = Plan(name: UUID().uuidString, title: name, price: price, priority: priority, category: category, date: Date())
                context.insert(newPlan)
            }
            try? context.save()
            dismiss()
        } else {
            showAlert = true
        }
    }

    
    var body: some View {
        NavigationView {
            VStack{
                VStack(alignment: .leading, spacing: 8){
                    Text("Item name ")
                        .font(.caption)
                    TextField("\(category == .Needs ? "Gas" : "Cake")", text: $item)
                        .keyboardType(.numberPad)
                        .padding(6)
                        .font(.callout)
                        .background(
                            RoundedRectangle(cornerRadius: 5.0)
                                .stroke(.gray, lineWidth: 1)
                        )
                        .padding(.bottom)
                    Text("Money spent")
                        .font(.caption)
                    HStack {
                        Text("Rp")
                            .foregroundStyle(.gray)
                        TextField("1.000", text: $priceText)
                            .keyboardType(.numberPad)
                            .padding(6)
                            .font(.callout)
                            .background(
                                RoundedRectangle(cornerRadius: 5.0)
                                    .stroke(.gray, lineWidth: 1)
                            )
                    }
                    if maxAllocation > 0{
                        Text("You can only add up to Rp\(maxAllocation) more from savings")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .padding([.bottom], 16)
                    } else {
                        Text("")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    Text("Priority")
                        .font(.caption)
                    Picker("Priority", selection: $priority) {
                        ForEach(priorityOption, id: \.self) { p in
                            Text(p)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding([.trailing, .leading], 20)
                .padding([.top, .bottom], 32)
                .background(
                    RoundedRectangle(cornerRadius: 15.0)
                        .stroke(.gray, lineWidth: 1)
                )
            }
            .padding([.bottom], 390)
            .padding([.trailing, .leading], 32)
            .navigationTitle(editingPlan == nil ? "Add \(category)" : "Edit \(category)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    if let price = Int(priceText) {
                        onSave(name: item, price: price, priority: Priority(rawValue: priority)!)
                        dismiss()
                    }
                }
                .disabled(item.isEmpty || Int(priceText) ?? 0 < 100)
            )
        }
    }
}

//#Preview {
//    AddEditPlanView(maxAllocation: 0, category: Category.Needs)
//}
