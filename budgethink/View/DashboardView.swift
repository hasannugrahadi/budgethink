//
//  DashboardView.swift
//  budgethink
//
//  Created by MacBook on 15/05/25.
//

import SwiftUI
import SwiftData

fileprivate let rupiahFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = "."
    formatter.maximumFractionDigits = 0
    return formatter
}()

struct DashboardView: View {

    var currentKey: Date
    
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Plan.date, order: .forward) private var allPlans: [Plan]
    @Query(sort: \Budget.date, order: .forward) private var allBudgets: [Budget]
    
    @State private var editPlan: Plan?
    @State private var tempBudgetText: String = ""
    @State private var selectedCategory = 0
    @State private var isAddPlan = false
    @State private var isSetUpdateBudget = false

    private var monthlyPlans: [Plan] {
        allPlans.filter { $0.date == currentKey }
    }
    
    private var totalNeedsUsed: Int {
        monthlyPlans.filter { $0.category == Category.Needs}.reduce(0) { $0 + $1.price }
    }
    
    private var totalWantsUsed: Int {
        monthlyPlans.filter { $0.category == Category.Wants }.reduce(0) { $0 + $1.price }
    }
    
    private var totalBudget: Int? {
        allBudgets.first(where: { $0.date == currentKey })?.totalBudget
    }
    
    private var currentNeeds: Int? {
        allBudgets.first(where: { $0.date == currentKey })?.currentNeedsBudget
    }
    
    private var currentWants: Int? {
        allBudgets.first(where: { $0.date == currentKey })?.currentWantsBudget
    }
    
    private var currentSaving: Int? {
        allBudgets.first(where: { $0.date == currentKey })?.currentSavingsBudget
    }
    
    private var currentBudget: Int? {
        if let needs = currentNeeds,
           let wants = currentWants,
           let saving = currentSaving {
            return needs + wants + saving
        } else {
            return nil
        }
    }
    
    private let months = Calendar.current.monthSymbols
    private let years: [Int] = {
        let currentYear = Calendar.current.component(.year, from: Date())
        return Array((currentYear-5)...(currentYear+5))
    }()

    
    private func determineCategoryPlan(category: Int) -> Category{
        switch category{
        case 0: return Category.Needs
        case 1: return Category.Wants
        default: return Category.Needs
        }
    }
    
    private func formatCurrency(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.numberStyle = .currency
        formatter.currencySymbol = "Rp"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "Rp 0"
    }
    
    private func deletePlan(_ plan: Plan) {
//        guard let budget = monthly.first(where: { $0.date == plan.date }) else { return }
//
//        switch plan.category {
//        case .Needs:
//            budget.currentNeedsBudget += plan.price
//        case .Wants:
//            budget.currentWantsBudget += plan.price
//        }
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save context: \(error)")
//        }
    }

    var body: some View {
        VStack{
            //MARK: Budget Overview
            VStack(alignment: .leading, spacing: 8) {
                Text("Budget Plan")
                    .foregroundStyle(.gray)
                    .font(.callout)
                    .bold()
                HStack(alignment: .bottom){
                    Text(currentBudget.map(formatCurrency) ?? "Rp-")
                        .font(.title)
                        .bold()
                    Text("/ \(totalBudget.map(formatCurrency) ?? "Rp-")")
                }
                Button(action: {isSetUpdateBudget = true}){
                    Label(
                        title: {
                            Text({totalBudget != nil ? "Update Budget" : "Set Budget"}())
                                .font(.callout)
                        },
                        icon: {
                            Image(systemName: "cart.fill")
                        }
                    )
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 8)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .sheet(isPresented: $isSetUpdateBudget) {
                    AddEditBudgetView(totalBudget: totalBudget, dateMonth: currentKey)
                }
                VStack(spacing: 12){
                    HStack {
                        Text("Needs (50%)")
                            .font(.caption)
                        Spacer()
                        Text("\(formatCurrency(currentNeeds ?? 0)) / \(formatCurrency((totalBudget ?? 0) * 50 / 100))")
                            .font(.caption)
                    }
                    ProgressView(value: Double(currentNeeds ?? 1), total: Double((totalBudget ?? 0) * 50 / 100))
                        .padding(.bottom, 8)
                    HStack {
                        Text("Wants (30%)")
                            .font(.caption)
                        Spacer()
                        Text("\(formatCurrency(currentWants ?? 0)) / \(formatCurrency((totalBudget ?? 0) * 30 / 100))")
                            .font(.caption)
                    }
                    ProgressView(value: Double(currentWants ?? 1), total: Double((totalBudget ?? 0) * 30 / 100))
                        .padding(.bottom, 8)
                        .padding(.bottom, 8)
                    HStack {
                        Label("Savings (20%)", systemImage: "wallet.pass")
                            .font(.caption)
                            .bold()
                        Spacer()
                        Text("\(formatCurrency(currentSaving ?? 0))")
                            .font(.caption)
                            .bold()
                    }
                }
                .padding(4)
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            //MARK: Needs Wants Segmented
            VStack(spacing: 15){
                Picker(selection: $selectedCategory, label: Text("category")){
                    Text("Needs")
                        .tag(0)
                    Text("Wants")
                        .tag(1)
                }
                .padding(.horizontal)
                .pickerStyle(.segmented)
                Button(action: {isAddPlan = true}){
                    Label(
                        title: {
                            Text("Add \(determineCategoryPlan(category: selectedCategory))")
                                .font(.callout)
                        },
                        icon: {
                            Image(systemName: "plus.circle.fill")
                        }
                    )
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .buttonStyle(.borderedProminent)
                .frame(maxWidth:.infinity)
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .disabled({totalBudget == nil}())
                .sheet(item: $editPlan) { plan in
                    AddEditPlanView(
                        maxAllocation: currentBudget ?? 0,
                        category: plan.category,
                        editingPlan: plan
                    )
                }
                .sheet(isPresented: $isAddPlan) {
                    AddEditPlanView(
                        maxAllocation: currentBudget ?? 0,
                        category: determineCategoryPlan(category: selectedCategory),
                        editingPlan: nil
                    )
                }
                ScrollView {
                    if allPlans.isEmpty {
                        VStack{
                            Image("no-plan-added")
                                .resizable()
                                .frame(width: 200, height: 200)
                            Text("It looks like you haven't added anything yet")
                                .foregroundStyle(.gray)
                                .font(.caption2)
                        }
                    } else {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(selectedCategory == 0 ?
                                    monthlyPlans.filter { $0.category == .Needs } : monthlyPlans.filter { $0.category == .Wants }) { plan in
                                PlanRowView(
                                    planList: plan,
                                    onEdit: { editPlan = $0 },
                                    onDelete: deletePlan
                                )

                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .scrollDisabled(allPlans.isEmpty)
            }
            .padding([.leading, .trailing, .top], 16 )
        }
    }
}

#Preview {
    DashboardView(currentKey: Date())
}
