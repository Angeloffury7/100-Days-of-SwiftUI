//
//  ContentView.swift
//  LengthConverter
//
//  Created by Woolly on 9/28/20.
//  Copyright © 2020 Woolly. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var inputLength = ""
    // inputUnit and outputUnit correspond to entry in units array.
    @State private var inputUnit = 0
    @State private var outputUnit = 0
    
    let units = ["m", "km", "ft", "yd", "mi"]
    
    // Formats output number, includes up to 5 decimal places.
    var outputLength: String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 5
        return formatter.string(from: NSNumber(value: inputLengthConverted.value))!
    }
    
    // Appends "s" to unit string if necessary.
    var unitString: String {
        var unitString = units[outputUnit]
        if outputUnit == 3 && inputLengthConverted.value > 1 {
            unitString += "s"
        }
        return unitString
    }
    
    // Does length conversion, easy with Measurement<UnitLength>.
    var inputLengthConverted: Measurement<UnitLength> {
        let inputLength = Double(self.inputLength) ?? 0
        // Just in case: defaults to meters if there was an issue with the unit selection.
        let inputUnit = getUnitLength(from: self.inputUnit) ?? UnitLength.meters
        let outputUnit = getUnitLength(from: self.outputUnit) ?? UnitLength.meters
        
        let inputMeasurement = Measurement<UnitLength>(value: inputLength, unit: inputUnit)
        let outputMeasurement = inputMeasurement.converted(to: outputUnit)
        
        return outputMeasurement
    }
    
    // Returns the UnitLength corresponding to the unit selected from the units array.
    func getUnitLength(from: Int) -> UnitLength? {
        switch from {
        case 0: return UnitLength.meters
        case 1: return UnitLength.kilometers
        case 2: return UnitLength.feet
        case 3: return UnitLength.yards
        case 4: return UnitLength.miles
        default: return nil
        }
    }
    
    // Creates and returns the Picker for the unit selection and binding variable.
    func unitPicker(for unit: Binding<Int>, header: String) -> some View {
        Picker(header, selection: unit) {
            ForEach(0..<units.count) {
                Text("\(units[$0])")
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Input Length", text: $inputLength)
                        .keyboardType(.decimalPad)
                }
                Section(header: Text("Input Unit")) {
                    unitPicker(for: $inputUnit, header: "Input Unit")
                }
                Section(header: Text("Output Unit")) {
                    unitPicker(for: $outputUnit, header: "Output Unit")
                }
                Section {
                    Text("\(outputLength) \(unitString)")
                }
            }.navigationBarTitle("Length Converter")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
