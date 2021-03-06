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
    var movementHistory = [(initalLocation: Location, placingLocation: Location, piece: Piece)]() // Tuple with ( initial location , placing location, piece )
    
    // Modal
    @Published var isModalVisible = false
    @Published var modalContent : ModalContent = .empty

    
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
    
    func resetBoard() {
        a_BoardSquare = [[BoardSquare]]() // Array of the board
        globalOffset = CGSize.zero // Offset used for dragging the piece
        piece = Piece.empty // Piece being dragged
        pieceLocation = Location.init(x: 0, y: 0) // Initial location of the piece being dragged
        piecePlacing = Location.init(x: 0, y: 0) // Last location the user passed his mouse when draging a piece
        isMovingPiece = false
        playerTurn = "Light" // Player turn to play
        isModalVisible = false
        initBoard()
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
    func forEachMovement(_ function : (Location)->(), piece: Piece, pieceLocation : Location, board: [[BoardSquare]]) {
        for move in piece.movement {
            if piece.movementType == "Multiplied" {
                var foundFirstPiece = false
                for mult in 1...7 {
                    let possibleLocation = Location.init(x: (move.x * mult) + pieceLocation.x, y: (move.y * mult) + pieceLocation.y)
                    if (possibleLocation.isValidLocation() && !foundFirstPiece) {
                        function(possibleLocation)
                        if locationHasPiece(location: possibleLocation, board: board) {
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
                        if possibleAttack.isValidLocation() {
                            function(possibleAttack)
                            
                        }
                    }
                }
                let possibleLocation = Location.init(x: move.x + pieceLocation.x, y: move.y + pieceLocation.y)
                if (possibleLocation.isValidLocation()) {
                    function(possibleLocation)
                }
            }
        }
    }
    
    // Finc: Get all possible movement of the piece in a specific location, even not valid movements
    func getPossibleMovements(piece : Piece, location: Location, board: [[BoardSquare]]) -> [Location] {
        var possibleLocations = [Location]()
        
        forEachMovement({ (possibleLocation) in
            possibleLocations.append(possibleLocation)
        }, piece: piece, pieceLocation: location, board: board)
        
        return possibleLocations
    }
    
    func updateBoardSquares() {
        // Special pawn movements
        if isAnPassantMovement(location: piecePlacing) {
            if playerTurn == "Light" {
                a_BoardSquare[piecePlacing.y + 1][piecePlacing.x].piece = Piece.empty
            }
            else {
                a_BoardSquare[piecePlacing.y - 1][piecePlacing.x].piece = Piece.empty
            }
        }
        else if isPromotionMovement(location: piecePlacing) {
            isModalVisible = true
            modalContent = .promotion
        }
        
        a_BoardSquare[pieceLocation.y][pieceLocation.x].piece = Piece.empty
        a_BoardSquare[piecePlacing.y][piecePlacing.x].piece = piece
        
        // King is in check
        let attackedKingColor = playerTurn == "Light" ? "Dark" : "Light"
        if kingIsInCheck(kingColor: attackedKingColor, board: a_BoardSquare) {
            var kingLocation = findKing(color: attackedKingColor, board: a_BoardSquare)
            a_BoardSquare[kingLocation.y][kingLocation.x].color = .red
            if kingIsInCheckMate(kingColor: attackedKingColor, board : a_BoardSquare) {
                isModalVisible = true
                modalContent = .playerWon
            }
        }
    }
    
    // Func: If the piece being draged is moved to a valid square, move the piece
    func handlePiecePositioning() {
        let possibleMovements = getPossibleMovements(piece: piece, location: pieceLocation, board: a_BoardSquare)
        let validMovements = filterValidMovements(movements: possibleMovements, piece: piece, pieceLocation: pieceLocation, board: a_BoardSquare)
        let found = validMovements.filter{
            return $0.x == piecePlacing.x && $0.y == piecePlacing.y
        }.count > 0
        // if the movement the player choose was in a valid movement, accept the movement
        hideValidMovements()
        if found {
            // King is in check
            var nextBoard = a_BoardSquare
            nextBoard[pieceLocation.y][pieceLocation.x].piece = .empty
            nextBoard[piecePlacing.y][piecePlacing.x].piece = piece
            if !kingIsInCheck(kingColor: playerTurn, board: nextBoard) {
                resetSquareColors()
                updateBoardSquares()
                movementHistory.append((pieceLocation, piecePlacing, piece))
                changePlayerTurn()
            }
        }
    }

    func showValidMovements() {
        let possibleMovements = getPossibleMovements(piece: piece, location: pieceLocation, board: a_BoardSquare)
        let validMovements = filterValidMovements(movements : possibleMovements, piece: piece, pieceLocation: pieceLocation, board: a_BoardSquare)
        
        for move in validMovements {
            a_BoardSquare[move.y][move.x].color = auxColor
        }
    }
    
    func hideValidMovements() {
        let possibleMovements = getPossibleMovements(piece: piece, location: pieceLocation, board: a_BoardSquare)
        let validMovements = filterValidMovements(movements : possibleMovements, piece: piece, pieceLocation: pieceLocation, board: a_BoardSquare)
        
        for move in validMovements {
            var color = colorOne
            if isOddNumber(move.y) != isOddNumber(move.x) {
                color = colorTwo
            }
            a_BoardSquare[move.y][move.x].color = color
        }
    }
    
    // Func: Reset Color witch are not being draged
    func resetSquareColors() {
        for collum in 0...7 {
            for row in 0...7 {
                var color = colorOne
                if isOddNumber(collum) != isOddNumber(row) {
                    color = colorTwo
                }
                a_BoardSquare[collum][row].color = color
            }
        }
    }
    
    func locationHasPiece(location : Location, board: [[BoardSquare]]) -> Bool {
        return board[location.y][location.x].piece != .empty
    }
    
    func filterValidMovements(movements: [Location], piece: Piece, pieceLocation: Location, board: [[BoardSquare]], onlyPawnAttack : Bool = false) -> [Location] {
        var validMovements = [Location]()
        
        for move in movements {
            if move.isValidLocation() {
                if piece.type == "Pawn" {
                    // Is first double jump
                    if (move.y - pieceLocation.y == 2) || (move.y - pieceLocation.y == -2) && !onlyPawnAttack {
                        if piece == .lightPawn && pieceLocation.y == 6 && (move.y - pieceLocation.y == -2) && !locationHasPiece(location: Location(x: pieceLocation.x, y: pieceLocation.y - 1), board: board) && !locationHasPiece(location: Location(x: pieceLocation.x, y: pieceLocation.y - 2), board: board) {
                            validMovements.append(move)
                        }
                        else if piece == .darkPawn && pieceLocation.y == 1 && (move.y - pieceLocation.y == 2) && !locationHasPiece(location: Location(x: pieceLocation.x, y: pieceLocation.y + 1),board: board) && !locationHasPiece(location: Location(x: pieceLocation.x, y: pieceLocation.y + 2),board: board) {
                            validMovements.append(move)
                        }
                    }
                    // Is one square movement
                    else {
                        // Go up one square
                        if !locationHasPiece(location: move, board: board) && !isPawnAttack(location: pieceLocation, movement: move, board: board) && !onlyPawnAttack{
                            validMovements.append(move)
                        }
                        // Its a capture movement
                        else if isPawnAttack(location: pieceLocation, movement: move, board: board) {
                            // Normal capture
                            if locationHasPiece(location: move, board: board) && isOpponetPiece(location: move, piece: piece, board: board) {
                                validMovements.append(move)
                            }
                            // An passant capture
                            else if isAnPassantMovement(location: move) {
                                validMovements.append(move)
                            }
                        }
                    }
                }
                else {
                    if locationHasPiece(location: move, board: board) {
                        if isOpponetPiece(location: move, piece: piece, board: board) {
                            validMovements.append(move)
                        }
                    }
                    if board[move.y][move.x].piece == .empty {
                        validMovements.append(move)
                    }
                }
            }
        }
        
        return validMovements
    }
    
    func isPawnAttack(location : Location, movement: Location, board: [[BoardSquare]]) -> Bool {
        return location.x != movement.x
    }
    
    func isOpponetPiece(location : Location, piece: Piece, board: [[BoardSquare]]) -> Bool {
        return piece.color != board[location.y][location.x].piece.color
    }
    
    func changePlayerTurn() {
        playerTurn = (playerTurn == "Light" ? "Dark" : "Light")
    }
    
    func isAnPassantMovement(location: Location) -> Bool {
        if let lastMovement = movementHistory.last {
            let lastMovementX = lastMovement.placingLocation.x
            let lastMovementY = lastMovement.placingLocation.y
            
            let areInTheSameRow = (pieceLocation.y == lastMovementY)
            
            return lastMovementWasDoubleJump() && (location.x == lastMovementX) && areInTheSameRow
        }
        return false
    }
        
    func lastMovementWasDoubleJump() -> Bool {
        if let lastMovement = movementHistory.last {
            let initialLocation = lastMovement.initalLocation
            let placingLocation = lastMovement.placingLocation
            
            return ((placingLocation.y - initialLocation.y == 2) || (placingLocation.y - initialLocation.y == -2))
        }
        return false
    }
    
    func isPromotionMovement(location : Location) -> Bool {
        if piece.type == "Pawn" {
            if ( playerTurn == "Light" && piecePlacing.y == 0 ) || ( playerTurn == "Dark" && piecePlacing.y == 7 ){
                return true
            }
            return false
        }
        return false
    }
    
    // Promotion
    func promotePawn (to piece : Piece) {
        self.piece = piece
        isModalVisible = false
        
        if let lastMovementLocation = movementHistory.last?.placingLocation {
            a_BoardSquare[lastMovementLocation.y][lastMovementLocation.x].piece = piece
        }
    }
    
    func kingIsInCheck (kingColor: String, board : [[BoardSquare]]) -> Bool {
        let kingLocation = findKing(color: kingColor, board: board)

        for collum in board {
            for square in collum {
                if square.piece != .empty && square.piece.color != kingColor {
                    let piece = square.piece
                    let possibleMovements = getPossibleMovements(piece: piece, location: square.position, board: board)
                    let validMovements = filterValidMovements(movements : possibleMovements, piece: piece, pieceLocation: square.position, board: board, onlyPawnAttack: true)
                    for movement in validMovements {
                        if movement.x == kingLocation.x && movement.y == kingLocation.y {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    func kingIsInCheckMate(kingColor: String, board : [[BoardSquare]]) -> Bool {
        let kingPiece = kingColor == "Light" ? Piece.lightKing : Piece.darkKing
        let kingLocation = findKing(color: kingColor, board: board)
        let kingMovemets = getPossibleMovements(piece: kingPiece, location: kingLocation, board: board)
        let kingValidMovements = filterValidMovements(movements: kingMovemets, piece: kingPiece, pieceLocation: kingLocation, board: board)
        var kingSquaresBeingAttacked = [Location]()
        
        for collum in board {
            for square in collum {
                if square.piece != .empty && square.piece.color == kingColor {
                    let piece = square.piece
                    let possibleMovements = getPossibleMovements(piece: piece, location: square.position, board: board)
                    let validMovements = filterValidMovements(movements : possibleMovements, piece: piece, pieceLocation: square.position, board: board, onlyPawnAttack: true)
                    for movement in validMovements {
                        
                        var nextBoard = a_BoardSquare
                        nextBoard[square.position.y][square.position.x].piece = .empty
                        nextBoard[movement.y][movement.x].piece = piece
                        
                        if !kingIsInCheck(kingColor: kingColor, board: nextBoard) {
                            return false
                        }
                    }
                }
            }
        }
        return true
    }
    
    func findKing(color : String, board: [[BoardSquare]]) -> Location {
        for collum in board {
            for square in collum {
                var piece = square.piece
                if piece.type == "King" && piece.color == color{
                    return square.position
                }
            }
        }
        return Location(x: -1, y: -1)
    }
}
