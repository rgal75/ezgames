import Foundation
import SwiftUI
import Testing
import ViewInspector

@testable import Game2048

@MainActor
final class GameViewTests: @unchecked Sendable {
    @Test("GameView shows a board of 2x2 tiles")
    func testBoardSize() async throws {
        let initialBoard = [
            [2, 0],
            [2, 0]
        ]
        let game = GameModel(initialBoard: initialBoard)
        let sut = GameView(game: game)
        
        let tiles = try sut.inspect().findAll(ViewType.View<TileView>.self)
        #expect(tiles.count == 4, "Expected a board of 2x2 tiles, got \(tiles.count)")
        #expect(try sut.inspect().find(viewWithId: "tile[0, 0]").text().string() == "2")
        #expect(try sut.inspect().find(viewWithId: "tile[0, 1]").text().string() == "0")
        #expect(try sut.inspect().find(viewWithId: "tile[1, 0]").text().string() == "2")
        #expect(try sut.inspect().find(viewWithId: "tile[1, 1]").text().string() == "0")
    }
    
    @Test("when the user swipes the game board, GameView gets updated")
    func testSwipeUpdatesGameView() async throws {
        let initialBoard = [
            [2, 0],
            [2, 0]
        ]
        let game = GameModel(initialBoard: initialBoard)
        let sut = GameView(game: game)
        
        var tileValues = [
            ["-1", "-1"],
            ["-1", "-1"]
        ]
        try await ViewHosting.host(sut) {
            sut.inspect { inspectableView in
                let dragValue = DragGesture.Value(
                    time: .now,
                    location: CGPoint(x: 50, y: 100),
                    startLocation: CGPoint(x: 50, y: 50),
                    velocity: CGVector(dx: 0, dy: 100)
                )
                let swipeDownGesture = try sut.inspect().find(ViewType.VStack.self).gesture(DragGesture.self)
                try swipeDownGesture.callOnEnded(value: dragValue)
                
                tileValues[0][0] = try inspectableView.find(viewWithId: "tile[0, 0]").text().string()
                tileValues[0][1] = try inspectableView.find(viewWithId: "tile[0, 1]").text().string()
                tileValues[1][0] = try inspectableView.find(viewWithId: "tile[1, 0]").text().string()
                tileValues[1][1] = try inspectableView.find(viewWithId: "tile[1, 1]").text().string()
            }
            
        }
        
        #expect(tileValues[0][0] == "0")
        #expect(tileValues[0][1] == "0")
        #expect(tileValues[1][0] == "4")
        #expect(tileValues[1][1] == "0")
    }
}
