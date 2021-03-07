//
//  ContentView.swift
//  Chess
//
//  Created by Nelogica on 06/03/21.
//

import SwiftUI

struct ContentView: View {
    
    var a_BoardSquare = [BoardSquare]()
    
    var colorOne: Color = .green
    var colorTwo: Color = .white
    
    init() {
        initBoard()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<8) { row in
                HStack(spacing: 0) {
                    ForEach(0..<8) { collum in
                        VStack(spacing: 0) {
                            a_BoardSquare[row * 8 + collum]
                        }
                    }
                }
            }
        }
    }
    
    mutating func initBoard() {
        
        let initialBoard = "ppppp1pp|8|8|8|8|8|8|p7"
        
        let decodedBoard = decodeBoardPiecesString(board: initialBoard)
        
        for row in 0...7 {
            for collum in 0...7 {
                if isOddNumber(collum) {
                    self.a_BoardSquare.append(BoardSquare(color: isOddNumber(row) ? colorOne : colorTwo, piece: decodedBoard[row * 8 + collum]))
                } else {
                    self.a_BoardSquare.append(BoardSquare(color: isOddNumber(row) ? colorTwo : colorOne, piece: decodedBoard[row * 8 + collum]))
                }
            }
        }
    }
    
    func decodeBoardPiecesString(board : String) -> [Piece] {
        var a_BoardSquare = [Piece]()
        
        for square in board {
            switch square {
            case "p":
                a_BoardSquare.append(PieceEnum.lightPawn.inicialize)
            case "|":
                break
            default:
                if let spaces = Int(String(square)) {
                    for _ in 1...spaces {
                        a_BoardSquare.append(PieceEnum.empty.inicialize)
                    }
                }
            }
        }
        
        return a_BoardSquare
    }
    
    func isOddNumber(_ number: Int) -> Bool {
        return number % 2 == 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
