//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Woolly on 10/4/20.
//  Copyright © 2020 The Woolly Co. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Prominent Title")
            .prominentTitle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - Challenge 1: Custom Modifier & Extension

struct ProminentTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            .font(.largeTitle)
    }
}

extension View {
    func prominentTitle() -> some View {
        self.modifier(ProminentTitle())
    }
}
