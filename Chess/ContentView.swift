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
        for row in 0...7 {
            for collum in 0...7 {
                if isOddNumber(collum) {
                    self.a_BoardSquare.append(BoardSquare(color: isOddNumber(row) ? colorOne : colorTwo))
                } else {
                    self.a_BoardSquare.append(BoardSquare(color: isOddNumber(row) ? colorTwo : colorOne))
                }
            }
        }
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
