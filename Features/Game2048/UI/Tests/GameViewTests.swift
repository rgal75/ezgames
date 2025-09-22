import Foundation
import SwiftUI
import Testing
import ViewInspector

@testable import Game2048

@MainActor
struct GameViewTests {
    @Test("GameView shows a board of 4x4 tiles")
    func testBoardSize() async throws {
        let sut = GameView()
        let board = try sut.inspect().findAll(ViewType.HStack.self).count
        #expect(board == 4, "Expected a board of 4x4 tiles, got \(board)")
    }
} 
