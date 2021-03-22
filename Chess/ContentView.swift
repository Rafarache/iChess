//
//  ContentView.swift
//  Chess
//
//  Created by Nelogica on 06/03/21.
//

import SwiftUI


struct ContentView: View {
    
    @ObservedObject var board : Board = .shared
    
    
    init() {
        board.initBoard()
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) { ForEach(0..<8) { row in
                    HStack(spacing: 0) { ForEach(0..<8) { collum in
                        board.a_BoardSquare[row][collum]
                        }
                    }
                }
            }
            VStack(spacing: 0) { ForEach(0..<8) { row in
                    HStack(spacing: 0) { ForEach(0..<8) { collum in
                        if ( collum == board.pieceLocation.x  && row == board.pieceLocation.y && board.isMovingPiece) {
                            Image(board.piece.image)
                                .frame(width: board.squareSize, height: board.squareSize, alignment: .center)
                                .offset(board.globalOffset)
                            }
                        else {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: board.squareSize, height: board.squareSize, alignment: .center)
                            }
                        }
                    }
                }
            }
            if board.isModalVisible {
                Modalview()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
