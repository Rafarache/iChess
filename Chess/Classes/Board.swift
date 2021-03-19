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
    
    // Colors
    var colorOne: Color = .white // Main color
    var colorTwo: Color = .green // Secondary color
    var auxColor: Color = Color.yellow
    var auxColorOpacity: Double = Double(0.4)
    
    // Constants
    let squareSize = CGFloat(60)
    
    // Board History
    var movementHistory = [(Location, Location, Piece)]() // Tuple with ( initial location , placing location, piece )
    
    @Published var a_BoardSquare = [[BoardSquare]]() // Array of the board
    @Published var globalOffset : CGSize = CGSize.zero // Offset used for dragging the piece
    @Published var piece : Piece = Piece.empty // Piece being dragged
    @Published var pieceLocation : Location = Location.init(x: 0, y: 0) // Initial location of the piece being dragged
    @Published var piecePlacing : Location = Location.init(x: 0, y: 0) // Last location the user passed his mouse when draging a piece
    @Published var isMovingPiece : Bool = false
    @Published var playerTurn : String = "Light" // Player turn to play
    
    // Func: Initializes the board with their respective:
    //  - Color, Piece, Size, Position
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
    
    // Func: Return an array of all pieces start Locations
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

    // Func: Iterates throught all possible movements of the piece and retuns a list cotaining all of them
    func forEachMovement(_ function : (Location)->()) {
        for move in piece.movement {
            if piece.movementType == "Multiplied" {
                var foundFirstPiece = false
                for mult in 1...7 {
                    let possibleLocation = Location.init(x: (move.x * mult) + pieceLocation.x, y: (move.y * mult) + pieceLocation.y)
                    if (possibleLocation.isValidLocation() && !foundFirstPiece) {
                        function(possibleLocation)
                        if locationHasPiece(location: possibleLocation) {
                            foundFirstPiece = true
                        }
                    }
                }
            }
            else {
                if piece.type == "Pawn" {
                    let pawnAtackLocations = [
                        Location(x: pieceLocation.x + 1, y: pieceLocation.y + piece.movement[0].y),
                        Location(x: pieceLocation.x - 1, y: pieceLocation.y + piece.movement[0].y)
                    ]
                    for possibleAttack in pawnAtackLocations {
                        if possibleAttack.isValidLocation() { function(possibleAttack) }
                    }
                }
                let possibleLocation = Location.init(x: move.x + pieceLocation.x, y: move.y + pieceLocation.y)
                if (possibleLocation.isValidLocation()) {
                    function(possibleLocation)
                }
            }
        }
    }
    
    // Finc: Get all possible movement of the piece, even not valid movements
    func getPossibleMovements() -> [Location] {
        var possibleLocations = [Location]()
        
        forEachMovement({ (possibleLocation) in
            possibleLocations.append(possibleLocation)
        })
        
        return possibleLocations
    }
    
    // Func: If the piece being draged is moved to a valid square, move the piece
    func handlePiecePositioning() {
        let possibleMovements = getPossibleMovements()
        let validMovements = filterValidMovements(movements: possibleMovements)
        let found = validMovements.filter{
            return $0.x == piecePlacing.x && $0.y == piecePlacing.y
        }.count > 0
        // if the movement the player choose was in a valid movement, accept the movement
        if found {
            a_BoardSquare[pieceLocation.y][pieceLocation.x].piece = Piece.empty
            a_BoardSquare[piecePlacing.y][piecePlacing.x].piece = piece
            
            changePlayerTurn()
            movementHistory.append((pieceLocation, piecePlacing, piece))
        }
    }

    func showPossibleMovements() {
        let possibleMovements = getPossibleMovements()
        let validMovements = filterValidMovements(movements : possibleMovements)
        
        for move in validMovements {
            a_BoardSquare[move.y][move.x].color = auxColor
        }
    }
    
    // Func: hide all possible movements of piece, even if is not valid
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
    
    func filterValidMovements(movements : [Location]) -> [Location] {
        var validMovements = [Location]()
        
        for move in movements {
            if move.isValidLocation() {
                if piece.type == "Pawn" {
                    // Is first double jump
                    if (move.y - pieceLocation.y == 2) || (move.y - pieceLocation.y == -2) {
                        if piece == .lightPawn && pieceLocation.y == 6 && (move.y - pieceLocation.y == -2) {
                            validMovements.append(move)
                        }
                        else if piece == .darkPawn && pieceLocation.y == 1 && (move.y - pieceLocation.y == 2) {
                            validMovements.append(move)
                        }
                    }
                    // Is one square movement
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
    
    func isPawnAttack(movement : Location) -> Bool {
        return pieceLocation.x != movement.x
    }
    
    func isOpponetPiece(location : Location) -> Bool {
        return piece.color != a_BoardSquare[location.y][location.x].piece.color
    }
    
    func changePlayerTurn() {
        playerTurn = (playerTurn == "Light" ? "Dark" : "Light")
    }
}
