//
//  Astronauts.swift
//  Moonshot
//
//  Created by Woolly on 12/26/20.
//  Copyright © 2020 Woolly Co. All rights reserved.
//

import Foundation

struct Astronauts {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
}
