//
//  Piece.swift
//  Chess
//
//  Created by Nelogica on 06/03/21.
//

import Foundation

enum Piece : String {
    case lightPawn
    case empty
    
    var image : String {
        return self.rawValue
    }
    
    var name : String {
        return self.rawValue
    }
}
