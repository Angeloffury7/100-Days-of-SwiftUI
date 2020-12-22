//
//  AstronautView.swift
//  Moonshot
//
//  Created by Woolly on 12/21/20.
//  Copyright © 2020 Woolly Co. All rights reserved.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                VStack {
                    Image(astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text(astronaut.description)
                        .padding()
                        .layoutPriority(1)
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
