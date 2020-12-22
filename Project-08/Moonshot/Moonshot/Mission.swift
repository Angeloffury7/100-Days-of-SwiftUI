//
//  Mission.swift
//  Moonshot
//
//  Created by Woolly on 12/15/20.
//  Copyright © 2020 Woolly Co. All rights reserved.
//

import Foundation

struct Mission: Codable, Identifiable {
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    
    var displayName: String { "Apollo \(id)" }
    var imageName: String { "apollo\(id)" }
    var formattedLaunchDate: String {
        if let launchDate = launchDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: launchDate)
        } else {
            return "N/A"
        }
    }

    struct CrewRole: Codable {
        let name: String
        let role: String
    }
}
