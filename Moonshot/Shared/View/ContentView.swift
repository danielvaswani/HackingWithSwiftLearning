//
//  ContentView.swift
//  Shared
//
//  Created by Daniel Vaswani on 17/08/2021.
//

import SwiftUI



struct ContentView : View {
    
    let astronauts : [Astronaut] = Bundle.main.decode("astronauts.json")
    
    let missions : [Mission] = Bundle.main.decode("missions.json")
    
    //Challenge 3 show names or date
    @State private var showingNames = false
    
    
    //Challenge 3 show names or date
    func getFormattedNames(mission : Mission) -> String {
        var shortNames = [String]()
        var formattedString = ""
        
        for member in mission.crew {
            shortNames.append(member.name)
            for man in astronauts {
                if man.id == member.name{
                    formattedString += man.name
                }
                
            }
            formattedString += ", "
        }
        
        return String(formattedString.dropLast(2))
    }
    
    var body : some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)

                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        //Challenge 3 show names or date
                        ScrollView(.horizontal, showsIndicators: false) {
                            Text(showingNames ? getFormattedNames(mission: mission) : mission.formattedLaunchDate)
                        }
                    }
                }
            }
            .navigationBarTitle("Moonshot")
            //Challenge 3 show names or date
            .navigationBarItems(trailing: Button(showingNames ? "Show Dates" : "Show Names"){ self.showingNames.toggle()})
        }
    }
}

struct CodableExample : View {
    var body : some View {
        Button("Decode JSON") {
            let input = """
            
            {
                "name": "Taylor Swift",
                "address": {
                    "street": "555, Taylor Swift Avenue",
                    "city": "Nashville"
                }
            }
            """

            let data = Data(input.utf8)
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: data) {
                print(user.address.street)
            }
        }
    }
}

struct User: Codable {
    var name: String
    var address: Address
}

struct Address: Codable {
    var street: String
    var city: String
}

struct NavigationViewViewStackExample: View {
    var body: some View {
        NavigationView {
            List(0..<100) { row in
                    NavigationLink(destination: Text("Detail \(row)")) {
                        Text("Row \(row)")
                    }
                }
            .navigationBarTitle("SwiftUI")
        }
    }
}

struct LazyLoadListVsNonLazyScrollViewVStackExample : View {
    var body: some View {
//        ScrollView(.vertical) {
//            VStack(spacing: 10) {
                List {
                    ForEach(0 ..< 100) {
                        CustomText("Item \($0)")
                            .font(.title)
                    }
                }
            }
//            .frame(maxWidth: .infinity)
//        }
//    }
}

struct CustomText: View {
    static var counter = 0
    
    var text: String

    var body: some View {
        Text(text)
    }

    init(_ text: String) {
        CustomText.counter += 1
        print("Creating a new CustomText \(CustomText.counter)")
        self.text = text
    }
}

struct GeometryReaderExample: View {
    var body: some View {
        VStack {
            GeometryReader { geo in
                Image("Example")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
