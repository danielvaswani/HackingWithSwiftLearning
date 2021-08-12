//
//  ContentView.swift
//  WeSplit
//
//  Created by Daniel Vaswani on 12/08/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var checkAmount = ""
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 2
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson: Double {
        //Challenge 3 Change Picker to TextField (Picker subtracts 2)
//        let peopleCount = Double(numberOfPeople + 2)
        let peopleCount = Double(numberOfPeople)
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount

        return amountPerPerson
    }
    // Challenge 2 add total
    var total : Double {
        let orderAmount = Double(checkAmount) ?? 0
        let tipSelection = Double(tipPercentages[tipPercentage])
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        
        return grandTotal
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    //Challenge 3 Change from Picker to TextField
                    TextField("Number of people", value: $numberOfPeople, formatter: NumberFormatter())
//                    Picker("Number of people", selection: $numberOfPeople){
//                           ForEach(2 ..< 100) {
//                               Text("\($0) people")
//                           }
//                       }
                }
                
                Section (header:Text("How much tip do you want to leave?")){
                    
                    
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                // Challenge 1 add header "Amount per person"
                Section (header: Text("Amount per person")){
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
                // Challenge 2 add new section for total
                Section(header: Text("Total")){
                    Text("$\(total, specifier: "%.2f")")
                }
            }
            .navigationBarTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
