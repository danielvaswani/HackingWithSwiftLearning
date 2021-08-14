//
//  ContentView.swift
//  BetterRest
//
//  Created by Daniel Vaswani on 12/08/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    //Challenge 3 remove alert, move sleeptime to main UI
    @State private var sleeptime = 0
//    @State private var alertTitle = ""
//    @State private var alertMessage = ""
//    @State private var showingAlert = false
    
    // create a range from those two
    var range : ClosedRange<Date> {
        // when you create a new Date instance it will be set to the current date and time
        let now = Date()
        // create a second Date instance set to one day in seconds from now
        let tomorrow = Date().addingTimeInterval(86400)
        return now ... tomorrow
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    //Challenge 3 return string instead of alert
    func calculateBedTime() -> String{
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: sleepTime)
//            alertMessage = formatter.string(from: sleepTime)
//            alertTitle = "Your ideal bedtime is…"
            
        } catch {
            return ""
        }
        //showingAlert = true
    }
    
    
    
    var body: some View {
        
        
        NavigationView {
            Form {
                //Challenge 1 change to Section
//                VStack(alignment: .leading, spacing:0){
                Section(header: Text("When do you want to wake up?") ){

                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents : .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                VStack(alignment : .leading, spacing: 0){
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                //Challenge 1 and 2 change VStack to Section, change coffee cups from Stepper to Picker
                Section(header: Text("Coffee Intake")){
//                    Text("Daily coffee intake")
                    Picker("Number of cups", selection: $coffeeAmount){
                        (ForEach(1 ..< 21, id: \.self) { index in
                            Text("\(index)") +
                                Text(index == 1 ?  " cup" : " cups")
                        })
                    }
                }
                VStack(alignment: .leading, spacing:10) {
                    Text("BetterRest Reccomends")
                        .font(.title)
                    HStack {
                        Spacer()
                        Text("\(calculateBedTime())")
                            .font(.title3)
                        Spacer()
                    }
                }
                
                //            DatePicker("Please enter a date", selection: $wakeUp, in: Date()...)
                //                .labelsHidden()
            }
            // Challenge 3 Remove alert and nav button
//            .alert(isPresented: $showingAlert) {
//                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//            }
            .navigationBarTitle("BetterRest")
//            .navigationBarItems(trailing : Button(action : calculateBedTime){ Text("Calculate") })
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
