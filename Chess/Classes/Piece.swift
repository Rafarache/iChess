//
//  Piece.swift
//  Chess
//
//  Created by Nelogica on 06/03/21.
//

import Foundation

enum Piece : String {
    case lightPawn, darkPawn
    case lightKing, darkKing
    case lightQueen, darkQueen
    case lightKnight, darkKnight
    case lightBishop, darkBishop
    case lightRook, darkRook
    case empty
    
    var image : String {
        return self.rawValue
    }
    
    var name : String {
        return self.rawValue
    }
    
    var movement : [Movement] {
        switch self {
        case .lightPawn: return [
            Movement.init(x: 0, y: -1),
            Movement.init(x: 0, y: -2),
        ]
        case .darkPawn: return [
            Movement.init(x: 0, y: 1),
            Movement.init(x: 0, y: 2)
        ]
        case .lightKing, .darkKing: return [
            Movement.init(x: 1, y: 0),
            Movement.init(x: -1, y: 0),
            Movement.init(x: 0, y: 1),
            Movement.init(x: 0, y: -1),
            Movement.init(x: 1, y: 1),
            Movement.init(x: 1, y: -1),
            Movement.init(x: -1, y: 1),
            Movement.init(x: -1, y: -1),
         ]
        case .lightQueen, .darkQueen: return [
            Movement.init(x: 1, y: 0),
            Movement.init(x: -1, y: 0),
            Movement.init(x: 0, y: 1),
            Movement.init(x: 0, y: -1),
            Movement.init(x: 1, y: 1),
            Movement.init(x: 1, y: -1),
            Movement.init(x: -1, y: 1),
            Movement.init(x: -1, y: -1),
        ]
        case .lightKnight, .darkKnight: return [
            Movement.init(x: 1, y: 2),
            Movement.init(x: 1, y: -2),
            Movement.init(x: -1, y: 2),
            Movement.init(x: -1, y: -2),
            Movement.init(x: 2, y: 1),
            Movement.init(x: 2, y: -1),
            Movement.init(x: -2, y: 1),
            Movement.init(x: -2, y: -1),        ]
        case .lightBishop, .darkBishop: return [
            Movement.init(x: 1, y: 1),
            Movement.init(x: 1, y: -1),
            Movement.init(x: -1, y: 1),
            Movement.init(x: -1, y: -1),
        ]
        case .lightRook, .darkRook: return [
            Movement.init(x: 1, y: 0),
            Movement.init(x: -1, y: 0),
            Movement.init(x: 0, y: 1),
            Movement.init(x: 0, y: -1),
        ]
        default: return []
        }
    }
    
    var pieceType : String {
        switch self {
        case .darkPawn, .darkKing, .darkQueen, .darkKnight, .darkBishop, .darkRook: return "Dark"
        case .lightKing, .lightPawn, .lightQueen, .lightKnight, .lightBishop, .lightRook: return "Light"
        default: return "None"
        }
    }
    
    var movementType : String {
        switch self {
        case .lightPawn, .darkPawn, .lightKing, .darkKing, .lightKnight, .darkKnight: return "Fixed"
        case .lightQueen, .darkQueen, .lightBishop, .darkBishop, .lightRook, .darkRook: return "Multiplied"
        default: return "Fixed"
        }
    }
}

struct Movement {
    var x : Int
    var y : Int
}


struct Location {
    var x : Int
    var y : Int
    
    func isValidLocation() -> Bool {
        if (x < 0 || x > 7) {
            return false
        }
        if (y < 0 || y > 7) {
            return false
        }
        return true
    }
}
