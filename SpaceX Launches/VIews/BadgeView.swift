//
//  BadgeView.swift
//  SpaceX Launches
//
//  Created by Jekabs Solovjovs on 31/07/2024.
//

import SwiftUI

struct BadgeView: View {
    let color: Color
    let text: String
    
    var body: some View {
        Text(text)
            .font(.callout)
            .foregroundStyle(.white)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .background(Capsule().fill(color))
    }
}

#Preview {
    BadgeView(color: Color.red, text: "Unsuccessful")
}
