//
//  ContentView.swift
//  WeSplit
//
//  Created by Woolly on 9/26/20.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""
//    @State private var numberOfPeople = 2
    // Challenge 3
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
//        let peopleCount = Double(numberOfPeople + 2)
        let peopleCount = Int(numberOfPeople) ?? 1
        return grandTotal / Double(peopleCount)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Your Order")) {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
//                    Picker("Number of People", selection: $numberOfPeople) {
//                        ForEach(2..<25) {
//                            Text("\($0) people")
//                        }
//                    }
                    // Challenge 3
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
                
                // Challenge 2
                Section(header: Text("Total Amount")) {
                    Text("$\(grandTotal, specifier: "%.2f")")
                }
                
                // Challenge 1
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
