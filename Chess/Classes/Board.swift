//
//  Board.swift
//  Chess
//
//  Created by Nelogica on 10/03/21.
//

import Foundation
import SwiftUI

class Board: ObservableObject {
    
    private init() { }
    static let shared = Board()
    
    var colorOne: Color = .green
    var colorTwo: Color = .white
    let squareSize = CGFloat(60)
    
    @Published var a_BoardSquare = [BoardSquare]()
    @Published var globalOffset : CGSize = CGSize.zero
    @Published var piece : Piece = Piece.empty
    @Published var piecePosition : Int = -1
    @Published var piecePlacing : Int = -1
    @Published var isMovingPiece : Bool = false
    
    func initBoard() {
        
        let initialBoard = "RNBQKBNR|PPPPPPPP|8|8|8|8|pppppppp|rnbqkbnr"
        
        let decodedBoard = decodeBoardPiecesString(board: initialBoard)
        
        for row in 0...7 {
            for collum in 0...7 {
                var color = colorOne
                if isOddNumber(collum) != isOddNumber(row) {
                    color = colorTwo
                }
                self.a_BoardSquare.append(
                    BoardSquare(
                        color: color,
                        piece: decodedBoard[row * 8 + collum],
                        size: squareSize,
                        position: row * 8 + collum)
                )
            }
        }
    }
    
    func decodeBoardPiecesString(board : String) -> [Piece] {
        var a_BoardSquare = [Piece]()
        
        for square in board {
            switch square {
            case "p": a_BoardSquare.append(Piece.lightPawn); break
            case "P": a_BoardSquare.append(Piece.darkPawn); break
            case "q": a_BoardSquare.append(Piece.lightQueen); break
            case "Q": a_BoardSquare.append(Piece.darkQueen); break
            case "k": a_BoardSquare.append(Piece.lightKing); break
            case "K": a_BoardSquare.append(Piece.darkKing); break
            case "n": a_BoardSquare.append(Piece.lightKnight); break
            case "N": a_BoardSquare.append(Piece.darkKnight); break
            case "b": a_BoardSquare.append(Piece.lightBishop); break
            case "B": a_BoardSquare.append(Piece.darkBishop); break
            case "r": a_BoardSquare.append(Piece.lightRook); break
            case "R": a_BoardSquare.append(Piece.darkRook); break
            case "|": break
            default:
                if let spaces = Int(String(square)) {
                    for _ in 1...spaces {
                        a_BoardSquare.append(Piece.empty)
                    }
                }
                break
            }
        }
        
        return a_BoardSquare
    }
    
    func isOddNumber(_ number: Int) -> Bool {
        return number % 2 == 1
    }

    
    func handlePiecePositioning() {
        a_BoardSquare[piecePosition].piece = Piece.empty
        a_BoardSquare[piecePlacing].piece = piece
    }
}
