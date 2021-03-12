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
    
    var moves : [Int] {
        switch self {
        case .lightPawn: return [-8]
        case .darkPawn: return [8]
        case .lightKing, .darkKing: return [-9,-8,-7,-1,1,7,8,9]
        case .lightQueen, .darkQueen: return [-9,-8,-7,-1,1,7,8,9]
        case .lightKnight, .darkKnight: return [19,-17,17,19]
        case .lightBishop, .darkBishop: return [-9,-7,7,9]
        case .lightRook, .darkRook: return [-8,-1,1,8]
        default: return []
        }
    }
}
