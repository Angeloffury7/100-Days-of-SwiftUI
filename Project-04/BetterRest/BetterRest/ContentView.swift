//
//  ContentView.swift
//  BetterRest
//
//  Created by Woolly on 10/11/20.
//  Copyright © 2020 The Woolly Co. All rights reserved.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        // Much better wake up time! :)
        components.hour = 10
        components.minute = 0
        return Calendar.current.date(from:components) ?? Date()
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                // Challenge 1: change VStacks to Sections.
                Section(header: Text("When do you want to wake up?").font(.subheadline)) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        // Wheel only on iOS.
                        .datePickerStyle(WheelDatePickerStyle())
                }
            
                Section(header: Text("Desired amount of sleep:").font(.subheadline)) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section(header: Text("Daily coffee intake:").font(.subheadline)) {
                    // I think this is more visually appealing than the result from Challenge 2, so I left it.
                    Stepper(value: $coffeeAmount, in: 0...20) {
                        // Changed range to start at 0.
                        Text("\(coffeeAmount) cup\(coffeeAmount == 1 ? "" : "s")")
                    }
                    
                    // Challenge 2: use Picker instead of Stepper for number of cups of coffee.
//                    Picker("Cups of coffee per day", selection: $coffeeAmount) {
//                        ForEach(0...20, id: \.self) { coffeeAmount in
//                            Text("\(coffeeAmount) cup\(coffeeAmount == 1 ? "" : "s")")
//                        }
//                    }
//                    .labelsHidden()
//                    .pickerStyle(WheelPickerStyle())
                }
                
                Section(header: Text("Your ideal bedtime:").font(.subheadline)) {
                    // Challenge 3: UI always shows bedtime.
                    // "When the state value changes, the view invalidates its appearance and recomputes the body."
                    // Thus the function gets called again and gets to use the new values of the @State variables.
                    Text(calculateBedtime()).font(.title)
                }
            }
            .navigationTitle("BetterRest")
        }
    }
    
    // Challenge 3: changed return type of function to String, eliminated the Alert.
    private func calculateBedtime() -> String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        var bedtime: String
        
        do {
            let model = try SleepCalculator(configuration: MLModelConfiguration())
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            bedtime = formatter.string(from: sleepTime)
        } catch {
            print(error)
            bedtime = "unable to calculate your bedtime"
        }
        return bedtime
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
