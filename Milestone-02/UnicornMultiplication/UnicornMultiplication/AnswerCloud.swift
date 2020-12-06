//
//  AnswerCloud.swift
//  UnicornMultiplication
//
//  Created by Woolly on 11/3/20.
//  Copyright © 2020 The Woolly Co. All rights reserved.
//

import SwiftUI

struct AnswerCloud: View {
    let answer: Int
    let width: CGFloat
    let color: Color
    
    init (_ answer: Int, width: CGFloat, color: Color) {
        self.answer = answer
        self.width = width
        self.color = color
    }
    
    var body: some View {
        ZStack {
            Image("cloud-\(Int.random(in:1...3))")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width)
            Text("\(answer)")
                .foregroundColor(color)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        }
    }
}

struct AnswerCloud_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            AnswerCloud(42, width: geo.size.width / 3, color: Color.black)
        }
    }
}
