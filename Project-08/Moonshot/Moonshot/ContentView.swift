//
//  ContentView.swift
//  Moonshot
//
//  Created by Woolly on 12/14/20.
//  Copyright © 2020 The Woolly Co. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var showingDates = true
    
    var body: some View {
        NavigationView {
            MissionListNavigationLinks(for: Missions.missions, showingDates: showingDates)
            .navigationBarTitle("Moonshot")
                .navigationBarItems(trailing: Button(showingDates ? "Show Names" : "Show Dates") {
                    showingDates.toggle()
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
