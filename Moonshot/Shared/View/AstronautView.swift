//
//  AstronautView.swift
//  Moonshot
//
//  Created by Daniel Vaswani on 17/08/2021.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    
    //Challenge 2 show missions gone by astronaut
    var missionsGone : [Mission] {
        let missions : [Mission] = Bundle.main.decode("missions.json")
        return missions.filter { mission in
            mission.crew.contains {
                $0.name == astronaut.id
            }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)

                    Text(self.astronaut.description)
                        .padding()
                        .layoutPriority(1)
                    //Challenge 2 show missions gone by astronaut
                    List(missionsGone) { mission in
                            Image(mission.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 44, height: 44)

                            VStack(alignment: .leading) {
                                Text(mission.displayName)
                                    .font(.headline)
                                Text(mission.formattedLaunchDate)
                            }
                        }
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")

    static var previews: some View {
        AstronautView(astronaut: astronauts[0])
    }
}
