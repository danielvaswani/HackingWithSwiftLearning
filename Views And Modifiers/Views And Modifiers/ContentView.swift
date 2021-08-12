//
//  ContentView.swift
//  Views And Modifiers
//
//  Created by Daniel Vaswani on 12/08/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var useRedText = false

       var body: some View {
        VStack {
            Text("Gryffindor")
                .font(.largeTitle)
            Text("Hufflepuff")
            Text("Ravenclaw")
            Text("Slytherin")
        }
        //Challenge 1 Create custom modifier
            .blueTitleStyle()
       }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//Challenge 1 Create custom modifier

struct BlueTitle : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func blueTitleStyle() -> some View {
        self.modifier(BlueTitle())
    }
}
