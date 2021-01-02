//
//  MissionList.swift
//  Moonshot
//
//  Created by Woolly on 1/1/21.
//  Copyright © 2021 Woolly Co. All rights reserved.
//

import SwiftUI

struct MissionListNavigationLinks: View {
    let missions: [Mission]
    let showingDates: Bool
    
    init(for missions: [Mission], showingDates: Bool = true) {
        self.missions = missions
        self.showingDates = showingDates
    }
    
    var body: some View {
        List(missions) { mission in
            NavigationLink(destination: MissionView(mission: mission)) {
                Image(mission.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                VStack(alignment: .leading) {
                    Text(mission.displayName)
                        .font(.headline)

                    Text(showingDates ? mission.formattedLaunchDate : missionMembersString(for: mission))
                    
                }
            }
        }
    }
    
    func missionMembersString(for mission: Mission) -> String {
        let astronauts = mission.participatingAstronauts
        var memberString = ""
        for index in 0..<astronauts.count {
            memberString.append(astronauts[index].name)
            if index + 1 < astronauts.count {
                memberString.append("\n")
            }
        }
        return memberString
    }
}

struct MissionList_Previews: PreviewProvider {
    static var previews: some View {
        MissionListNavigationLinks(for: Missions.missions)
    }
}
