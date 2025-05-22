//
//  Priority.swift
//  budgethink
//
//  Created by MacBook on 15/05/25.
//



enum Priority: String, CaseIterable, Codable{
    case Low
    case Medium
    case High
}

enum Category: String, Codable{
    case Needs
    case Wants
}
