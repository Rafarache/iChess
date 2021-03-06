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
    var position : Location
    
    @ObservedObject var board : Board = .shared
    
    @State var isMovingPiece : Bool = false
    @State var isHover = false
        
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .foregroundColor(color)
                .frame(width: size, height: size)
            if !isMovingPiece && piece.image != "empty" {
                Image(piece.image)
                    .resizable()
                    .frame(width: size, height: size, alignment: .center)
            }
        }
        .gesture( DragGesture()
                    .onChanged{ gesture in
                        if isPlayerTurn() {
                            board.globalOffset = gesture.translation
                            board.piece = piece
                            board.pieceLocation = position
                            board.isMovingPiece = true
                            self.isMovingPiece = true
                            board.showValidMovements()
                        }
                    }
                    .onEnded{ _ in
                        if isPlayerTurn() {
                            board.isMovingPiece = false
                            self.isMovingPiece = false
                            if piece != .empty {
                                board.handlePiecePositioning()
                            }
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
    
    func isPlayerTurn() -> Bool {
        return board.playerTurn == piece.color
    }
}

struct BoardSquare_Previews: PreviewProvider {
    static var previews: some View {
        BoardSquare(color: .red, piece: Piece.lightPawn, size: 70, position: Location.init(x: 0, y: 0))
    }
}
