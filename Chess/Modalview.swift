//
//  Modalview.swift
//  Chess
//
//  Created by Nelogica on 18/03/21.
//

import SwiftUI

struct Modalview: View {
    
    @ObservedObject var board : Board = .shared
    
    @State var piece : Piece = .empty
    
    var body: some View {
        VStack {
            switch board.modalContent {
            case .playerWon:
                VStack {
                    Text("\(board.playerTurn == "Light" ? "Dark" : "Light") pieces won!!")
                    Button("Start again", action: board.resetBoard)
                }
            case .settings:
                Text("Settings")
            case .promotion:
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Image(board.playerTurn == "Dark" ? Piece.lightQueen.image : Piece.darkQueen.image)
                            .frame(width: board.squareSize, height: board.squareSize, alignment: .center)
                            .onTapGesture(perform: {choosePiece(pieceName: "Queen")})
                        Image(board.playerTurn == "Dark" ? Piece.lightKnight.image : Piece.darkKnight.image)
                            .frame(width: board.squareSize, height: board.squareSize, alignment: .center)
                            .onTapGesture(perform: {choosePiece(pieceName: "Knight")})
                    }
                    HStack(spacing: 0) {
                        Image(board.playerTurn == "Dark" ? Piece.lightRook.image : Piece.darkRook.image)
                            .frame(width: board.squareSize, height: board.squareSize, alignment: .center)
                            .onTapGesture(perform: {choosePiece(pieceName: "Rook")})
                        Image(board.playerTurn == "Dark" ? Piece.lightBishop.image : Piece.darkBishop.image)
                            .frame(width: board.squareSize, height: board.squareSize, alignment: .center)
                            .onTapGesture(perform: {choosePiece(pieceName: "Bishop")})
                    }
                }
            default:
                Text("Help")
            }
        }
        .frame(minWidth: 0, maxWidth: board.squareSize * 4, minHeight: 0, maxHeight: board.squareSize * 4)
        .background(Color.white)
        .foregroundColor(.black)
    }
    
    func choosePiece (pieceName : String) {
        
        var piece = Piece.empty
        
        switch pieceName {
        case "Queen":
            piece = board.playerTurn == "Dark" ? Piece.lightQueen : Piece.darkQueen
        case "Knight":
            piece = board.playerTurn == "Dark" ? Piece.lightKnight : Piece.darkKnight
        case "Rook":
            piece = board.playerTurn == "Dark" ? Piece.lightRook : Piece.darkRook
        case "Bishop":
            piece = board.playerTurn == "Dark" ? Piece.lightBishop : Piece.darkBishop
        default:
            piece = .empty
        }
        
        board.promotePawn(to: piece)
    }
}

enum ModalContent {
    case settings
    case promotion
    case playerWon
    case empty
}

struct Modalview_Previews: PreviewProvider {
    static var previews: some View {
        Modalview()
    }
}
