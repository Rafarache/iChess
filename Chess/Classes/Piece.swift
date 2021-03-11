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
        case .lightKing, .darkKing: return [-1] 
        default: return []
        }
    }
}
