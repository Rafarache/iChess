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
    
    var colorOne: Color = .white
    var colorTwo: Color = .green
    var auxColor: Color = Color.yellow
    var auxColorOpacity: Double = Double(0.4)
    let squareSize = CGFloat(60)
    
    @Published var a_BoardSquare = [[BoardSquare]]()
    @Published var globalOffset : CGSize = CGSize.zero
    @Published var piece : Piece = Piece.empty
    @Published var piecePosition : Location = Location.init(x: 0, y: 0)
    @Published var piecePlacing : Location = Location.init(x: 0, y: 0)
    @Published var isMovingPiece : Bool = false
    
    func initBoard() {
        
        let initialBoard = "RNBQKBNR|PPPPPPPP|8|8|8|8|pppppppp|rnbqkbnr"
        
        let decodedBoard = decodeBoardPiecesString(board: initialBoard)
        
        for collum in 0...7 {
            var collumBoadSquares = [BoardSquare]()
            
            for row in 0...7 {
                var color = colorOne
                if isOddNumber(collum) != isOddNumber(row) {
                    color = colorTwo
                }
                collumBoadSquares.append(
                    BoardSquare(
                        color: color,
                        piece: decodedBoard[collum * 8 + row],
                        size: squareSize,
                        position: Location.init(x: collum, y: row))
                )
            }
            
            self.a_BoardSquare.append(collumBoadSquares)
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

    func forEachPossiblePosition(_ function : (Location)->()) {
        for move in piece.movement {
            if piece.movementType == "Multiplied" {
                for mult in 1...7 {
                    var stop = false
                    let possiblePosition = Location.init(x: (move.x * mult) + piecePosition.x, y: (move.y * mult) + piecePosition.y)
                    if (possiblePosition.isValid() && !stop) {
                        function(possiblePosition)
                    }
                    else {
                        stop = true
                    }
                }
            }
            else {
                let possiblePosition = Location.init(x: move.x + piecePosition.x, y: move.y + piecePosition.y)
                if (possiblePosition.isValid()) {
                    function(possiblePosition)
                }
            }
        }
    }
    
    func getPossibleMoves() -> [Location] {
        var possiblePositions = [Location]()
        
        forEachPossiblePosition({ (possiblePosition) in
            possiblePositions.append(possiblePosition)
        })
        
        return possiblePositions
    }
    
    func handlePiecePositioning() {
        let possibleMoves = getPossibleMoves()
        var filteredMoves =  possibleMoves.filter{
            return $0.x == piecePlacing.x && $0.y == piecePlacing.y
        }
        var found = possibleMoves.filter{
            return $0.x == piecePlacing.x && $0.y == piecePlacing.y
        }.count > 0
        if found {
            a_BoardSquare[piecePosition.x][piecePosition.y].piece = Piece.empty
            a_BoardSquare[piecePlacing.x][piecePlacing.y].piece = piece
        }
    }

    func showPossibleMove() {
        forEachPossiblePosition({ (possiblePosition) in
            a_BoardSquare[possiblePosition.x][possiblePosition.y].color = auxColor
        })
    }
    
    func hidePossibleMove() {
        forEachPossiblePosition({(possiblePosition) in
            var color = colorOne
            if isOddNumber(possiblePosition.x) != isOddNumber(possiblePosition.y) {
                color = colorTwo
            }
            a_BoardSquare[possiblePosition.x][possiblePosition.y].color = color
        })
    }
}
