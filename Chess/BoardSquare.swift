//
//  BoardSquare.swift
//  Chess
//
//  Created by Nelogica on 06/03/21.
//

import SwiftUI

struct BoardSquare: View {
    
    var color : Color
    var piece : Piece
    
    var size : CGFloat = 100
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .frame(width: size, height: size)
            Image(piece.image)
                .resizable()
                .frame(width: size, height: size, alignment: .center)
        }
    }
}

struct BoardSquare_Previews: PreviewProvider {
    static var previews: some View {
        BoardSquare(color: .red, piece: PieceEnum.lightPawn.inicialize)
    }
}
