//
//  RealView.swift
//  Slot Mashine
//
//  Created by YAQRUT on 2023-02-22.
//

import SwiftUI

struct RealView: View {
    var body: some View {
        Image("gfx-reel")
            .resizable()
            .modifier(ImageModifier())
    }
}

struct RealView_Previews: PreviewProvider {
    static var previews: some View {
        RealView()
    }
}
