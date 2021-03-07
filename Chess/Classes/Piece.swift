//
//  Piece.swift
//  Chess
//
//  Created by Nelogica on 06/03/21.
//

import Foundation

class Piece {
    
    var color : String
    var name : String
    var image : String
    
    internal init(color: String, name: String, image: String) {
        self.color = color
        self.name = name
        self.image = image
    }
}

enum PieceEnum {
    case lightPawn
    case empty
    
    var inicialize: Piece {
        switch self {
        case .lightPawn:
            return Piece(color: "light", name: "Pawn", image: "lightPawn")
        case .empty:
            return Piece(color: "nil", name: "nil", image: "nil")
        }
    }
    
}
