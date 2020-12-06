//
//  DropshadowText.swift
//  UnicornMultiplication
//
//  Created by Woolly on 11/3/20.
//  Copyright © 2020 The Woolly Co. All rights reserved.
//

import SwiftUI

struct DropshadowText: View {
    var text: String
    var dropshadowColor: Color
    
    init(_ text: String, dropshadowColor: Color) {
        self.text = text
        self.dropshadowColor = dropshadowColor
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Text(text)
                    .font(.custom("sweet purple", size: min(geo.size.height, geo.size.width) * 0.9))
                    .foregroundColor(dropshadowColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
                    .offset(x: 2, y: 2)
                    .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text(text)
                    .font(.custom("sweet purple", size: min(geo.size.height, geo.size.width) * 0.9))
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
                    .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
    }
}

struct DropshadowText_Previews: PreviewProvider {
    static var previews: some View {
        DropshadowText("hello, world!", dropshadowColor: .black)
            .foregroundColor(.green)
    }
}
