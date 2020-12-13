//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Woolly on 12/12/20.
//  Copyright © 2020 The Woolly Co. All rights reserved.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: ExpenseType
    let amount: Int
}

enum ExpenseType: String, CaseIterable, Codable {
    case Personal = "Personal"
    case Business = "Business"
}
