//
//  BoardSquare.swift
//  Chess
//
//  Created by Nelogica on 06/03/21.
//

import SwiftUI

struct BoardSquare: View {
    
    var color : Color
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .frame(width: 100, height: 100)
            Image("darkPawn")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
        }
    }
}

struct BoardSquare_Previews: PreviewProvider {
    static var previews: some View {
        BoardSquare(color: .red)
    }
}
