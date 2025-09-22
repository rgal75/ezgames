//
//  GameView.swift
//  Game2048
//
//  Created by Richard Gal on 2025. 03. 14..
//

import SwiftUI

public final class Game2048: Game2048Interface {
    public init() {}
    
    public func start() -> any View {
        GameView()
    }
}

// Game descriptions: https://rosettacode.org/wiki/2048
struct GameView: View {
    @State private var game = GameModel()
    var body: some View {
        VStack {
            ForEach(0..<game.boardSize.height, id: \.self) { row in
                HStack {
                    ForEach(0..<game.boardSize.width, id: \.self) { col in
                        let value = game.board[row][col]
                        if game.tileWasMergedInLastMoveAt(row: row, col: col) {
                            TileView(value: value, row: row, col: col)
                                .transition(.scale.combined(with: .opacity))
                                .animation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.5), value: value)
                        } else {
                            TileView(value: value, row: row, col: col)
                        }
                    }
                }
            }
            Text("\(gameResult)")
                .font(.headline)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .gesture(DragGesture().onEnded({ gesture in
            withAnimation {
                game.userDidSwipe(translation: gesture.translation)
            }
        }))
    }
    
    private var gameResult: String {
        switch game.gameResult {
        case .won:
            return "You won!"
        case .lost:
            return "Game over!"
        case .ongoing:
            return ""
        }
    }
}

#Preview {
    GameView()
}
