//
//  ContentView.swift
//  WeSplit
//
//  Created by Woolly on 9/26/20.
//  Copyright © 2020 Woolly. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""
    @State private var numberOfPeople = ""
    @State private var tipPercentage = 2
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var orderAmount: Double { Double(checkAmount) ?? 0 }
    var tipValue: Double {
        let tipSelection = Double(tipPercentages[tipPercentage])
        return orderAmount * (tipSelection / 100)
    }
    var grandTotal: Double { return tipValue + orderAmount }
    var totalPerPerson: Double {
        let peopleCount = Int(numberOfPeople) ?? 1
        return grandTotal / Double(peopleCount)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Your Order")) {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    TextField("Number of People", text: $numberOfPeople)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Tip Amount")) {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(0..<tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Total Amount")) {
                    Text("$\(grandTotal, specifier: "%.2f")")
                        // Challenge 2
                        .foregroundColor(tipPercentage == 4 ? .red : .black)
                }
                
                Section(header: Text("Amount Per Person")) {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
            }.navigationBarTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
