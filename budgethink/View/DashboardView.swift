//
//  DashboardView.swift
//  budgethink
//
//  Created by MacBook on 15/05/25.
//

import SwiftUI

struct DashboardView: View {
    
    @State private var selectedCategory = 0
    @State private var isAddPlan = false
    @State private var isFocused = false
    
    private var planList: [PlanGenericModel] = PlanGenericModel.dummies
    
    func detailItem(){
        
    }
    
    func placeholder(){}
    
    private func determineCategoryPlan(category: Int) -> Category{
        switch category{
        case 0: return Category.Needs
        case 1: return Category.Wants
        default: return Category.Needs
        }
    }
    
    private func determineColorPriority(priority: Priority) -> Color {
        switch priority{
            case Priority.Low: return .green
            case Priority.Medium : return .yellow
            case Priority.High: return .red
        }
    }
    
    var body: some View {
        VStack{
            //Budget Plan (Placeholder)
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).padding()
            //Needs Wants Segmented
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
                            Image(systemName: "plus.circle")
                        }
                    )
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .buttonStyle(.borderedProminent)
                .frame(maxWidth:.infinity)
                .tint(.indigo)
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .sheet(isPresented: $isAddPlan) {
                    AddPlanView(category: determineCategoryPlan(category: selectedCategory))
                }
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(planList) { plan in
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(plan.title)
                                        .bold()
                                        .font(.caption)
                                    Text("Rp\(plan.budget.formatted()),-")
                                        .font(.caption)
                                        .bold()
                                        .foregroundStyle(.gray)
                                    HStack {
                                        Text("\(plan.priority) priority")
                                            .font(.caption)
                                        Image(systemName: "star.circle.fill")
                                            .foregroundColor(determineColorPriority(priority: plan.priority))
                                    }
                                }
                                Spacer()
                                VStack(alignment: .center){
                                    Button(action: {isFocused = !isFocused}) {
                                        Image(systemName: isFocused ? "chevron.down.circle.fill" : "ellipsis.circle")
                                            .foregroundColor(.indigo)
                                    }
                                }
                                .animation(.snappy, value: isFocused)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15.0)
                                    .stroke(.indigo, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    DashboardView()
}
