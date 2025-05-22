//
//  Budget.swift
//  budgethink
//
//  Created by MacBook on 18/05/25.
//

import Foundation
import SwiftData

@Model
final class Budget: Identifiable {
    @Attribute(.unique) var id: UUID
    var date: Date
    var totalBudget: Int
    var currentNeedsBudget: Int
    var currentWantsBudget: Int
    var currentSavingsBudget: Int
    
    init(id: UUID = UUID(), monthYear: Date, totalBudget: Int, currentNeedsBudget: Int, currentWantsBudget: Int, currentSavingsBudget: Int) {
        self.id = id
        self.date = monthYear
        self.totalBudget = totalBudget
        self.currentNeedsBudget = currentNeedsBudget
        self.currentWantsBudget = currentWantsBudget
        self.currentSavingsBudget = currentSavingsBudget
    }
}
