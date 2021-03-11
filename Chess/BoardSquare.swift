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
    var size : CGFloat
    var position : Int
    
    @ObservedObject var board : Board = .shared
    
    @State var isMovingPiece : Bool = false
    @State var isHover = false
        
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .foregroundColor(isMovingPiece && piece != .empty ? .yellow : color)
                .frame(width: size, height: size)
            if !isMovingPiece {
                Image(piece.image)
                    .resizable()
                    .frame(width: size, height: size, alignment: .center)
            }
        }
        .gesture( DragGesture()
                    .onChanged{ gesture in
                        board.globalOffset = gesture.translation
                        board.piece = piece
                        board.piecePosition = position
                        board.isMovingPiece = true
                        self.isMovingPiece = true
                    }
                    .onEnded{ _ in
                        board.isMovingPiece = false
                        self.isMovingPiece = false
                        if piece != .empty {
                            board.handlePiecePositioning()
                        }
                    }
                 
        )
        .onHover(perform: { hovering in
            self.isHover = hovering
            if self.isHover == true {
                board.piecePlacing = position
            }
        })
    }
}

struct BoardSquare_Previews: PreviewProvider {
    static var previews: some View {
        BoardSquare(color: .red, piece: Piece.lightPawn, size: 70, position: 0)
    }
}
