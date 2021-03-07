//
//  ContentView.swift
//  Chess
//
//  Created by Nelogica on 06/03/21.
//

import SwiftUI

struct ContentView: View {
    
    
    var colorOne: Color = .black
    var colorTwo: Color = .white
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<8) { row in
                HStack(spacing: 0) {
                    ForEach(0..<8) { collum in
                        VStack(spacing: 0) {
                            if isOddNumber(number: row) {
                                Rectangle()
                                    .foregroundColor(isOddNumber(number: collum) ? colorOne : colorTwo)
                                    .frame(width: 100, height: 100)
                            }
                            else {
                                Rectangle()
                                    .foregroundColor(isOddNumber(number: collum) ? colorTwo : colorOne)
                                    .frame(width: 100, height: 100)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func isOddNumber(number: Int) -> Bool {
        return number % 2 == 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
