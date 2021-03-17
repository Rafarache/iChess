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
                        position: Location.init(x: row, y: collum))
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

    func forEachMovement(_ function : (Location)->()) {
        for move in piece.movement {
            if piece.movementType == "Multiplied" {
                var foundFirstPiece = false
                for mult in 1...7 {
                    let possibleLocation = Location.init(x: (move.x * mult) + piecePosition.x, y: (move.y * mult) + piecePosition.y)
                    if (possibleLocation.isValidLocation() && !foundFirstPiece) {
                        function(possibleLocation)
                        if locationHasPiece(location: possibleLocation) {
                            foundFirstPiece = true
                        }
                    }
                }
            }
            else {
                if pieceIsPawn() {
                    var pawnAtackLocations = [
                        Location(x: piecePosition.x + 1, y: piecePosition.y + piece.movement[0].y),
                        Location(x: piecePosition.x - 1, y: piecePosition.y + piece.movement[0].y)
                    ]
                    for possibleAttack in pawnAtackLocations {
                        if possibleAttack.isValidLocation() { function(possibleAttack) }
                    }
                }
                let possibleLocation = Location.init(x: move.x + piecePosition.x, y: move.y + piecePosition.y)
                if (possibleLocation.isValidLocation()) {
                    function(possibleLocation)
                }
            }
        }
    }
    
    func getPossibleMovements() -> [Location] {
        var possibleLocations = [Location]()
        
        forEachMovement({ (possibleLocation) in
            possibleLocations.append(possibleLocation)
        })
        
        return possibleLocations
    }
    
    func handlePiecePositioning() {
        let possibleMovements = getPossibleMovements()
        let filteredMovements = filterMovements(movements: possibleMovements)
        let found = filteredMovements.filter{
            return $0.x == piecePlacing.x && $0.y == piecePlacing.y
        }.count > 0
        if found {
            a_BoardSquare[piecePosition.y][piecePosition.x].piece = Piece.empty
            a_BoardSquare[piecePlacing.y][piecePlacing.x].piece = piece
        }
    }

    func showPossibleMovements() {
        
        var possibleMovements = getPossibleMovements()
        var validMovements = filterMovements(movements : possibleMovements)
        
        for move in validMovements {
            a_BoardSquare[move.y][move.x].color = auxColor
        }
    }
    
    func hidePossibleMovements() {
        forEachMovement({(possibleLocation) in
            var color = colorOne
            if isOddNumber(possibleLocation.x) != isOddNumber(possibleLocation.y) {
                color = colorTwo
            }
            a_BoardSquare[possibleLocation.y][possibleLocation.x].color = color
        })
    }
    
    func locationHasPiece(location : Location) -> Bool {
        return a_BoardSquare[location.y][location.x].piece != .empty
    }
    
    func filterMovements(movements : [Location]) -> [Location] {
        var validMovements = [Location]()
        
        for move in movements {
            if move.isValidLocation() {
                if pieceIsPawn() {
                    if (move.y - piecePosition.y == 2) || (move.y - piecePosition.y == -2) {
                        if piece == .lightPawn && piecePosition.y == 6 && (move.y - piecePosition.y == -2) {
                            validMovements.append(move)
                        }
                        else if piece == .darkPawn && piecePosition.y == 1 && (move.y - piecePosition.y == 2) {
                            validMovements.append(move)
                        }
                    }
                    else {
                        if !locationHasPiece(location: move) && !isPawnAttack(movement: move) {
                            validMovements.append(move)
                        }
                        else if locationHasPiece(location: move) && isPawnAttack(movement: move) && isOpponetPiece(location: move) {
                            validMovements.append(move)
                        }
                    }
                }
                else {
                    if locationHasPiece(location: move) {
                        if isOpponetPiece(location: move) {
                            validMovements.append(move)
                        }
                    }
                    if a_BoardSquare[move.y][move.x].piece == .empty {
                        validMovements.append(move)
                    }
                }
            }
        }
        
        return validMovements
    }
    
    func pieceIsPawn() -> Bool {
        return piece == .lightPawn || piece == .darkPawn
    }
    
    func isPawnAttack(movement : Location) -> Bool {
        return piecePosition.x != movement.x
    }
    
    func isOpponetPiece(location : Location) -> Bool {
        return piece.pieceType != a_BoardSquare[location.y][location.x].piece.pieceType
    }
}
