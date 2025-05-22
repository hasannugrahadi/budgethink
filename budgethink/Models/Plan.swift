import Foundation
import SwiftData

@Model
final class Plan{
    @Attribute(.unique) var name: String
    var title: String
    var price: Int
    var priority: Priority
    var category: Category
    var date: Date
    
    init(name: String, title: String, price: Int, priority: Priority, category: Category, date: Date) {
        self.name = name
        self.title = title
        self.price = price
        self.priority = priority
        self.category = category
        self.date = date
    }
}

