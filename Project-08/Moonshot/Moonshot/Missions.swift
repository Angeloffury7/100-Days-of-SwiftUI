//
//  Missions.swift
//  Moonshot
//
//  Created by Woolly on 12/26/20.
//  Copyright © 2020 Woolly Co. All rights reserved.
//

import Foundation

struct Missions {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
}
