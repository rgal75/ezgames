//
//  GameModelTests.swift
//  Game2048Tests
//
//  Created by Richard Gal on 2025. 03. 15..
//

import Foundation
import Testing

@testable import Game2048

struct GameModelTests {

    @Test("Creates a rectangular board")
    func testCreateBoard() async throws {
        let sut = GameModel(boardSize: (width: 6, height: 6))
        
        #expect(sut.board.count == 6, "Expected a board with 6 rows, got \(sut.board.count)")
        sut.board.enumerated().forEach { (rowIdx, row) in
            #expect(row.count == 6, "Expected row \(rowIdx) of size 6, got \(String(describing: row.count))")
        }
    }

    @Test("The board is filled with 0's having 2's at two positions")
    func testInitialBoard() async throws {
        let sut = GameModel(boardSize: (width: 10, height: 10))
        let twosCount = numberOf(2, on: sut.board)
        #expect(twosCount == 2, "Expected 2 twos on the board, got \(twosCount)")
    }
    
    // MARK: - Swipe Up
    @Test("Swiping up from an initial board moves the 2 twos to the top row")
    func testSwipeUpFromInitialBoard() async throws {
        let sut = GameModel(initialBoard: [
            [0, 0, 0, 0, 0],
            [0, 0, 0, 2, 0],
            [0, 0, 0, 0, 0],
            [0, 2, 0, 0, 0]
        ])

        sut.userDidSwipe(translation: CGSize(width: 2, height: -3))

        #expect(sut.board[0][1] == 2)
        #expect(sut.board[0][3] == 2)
        #expect(numberOf(0, on: sut.board) == 17)
        #expect(numberOf(2, on: sut.board) == 3)
    }
    
    @Test("Given the user has swiped up, when a 2 bumps into another 2, they merge into a 4")
    func testSwipeUpMerge() async throws {
        let sut = GameModel(initialBoard: [
            [0, 0, 0, 0, 0],
            [0, 2, 0, 2, 0],
            [0, 0, 0, 0, 0],
            [0, 2, 0, 0, 0]
        ])

        sut.userDidSwipe(translation: CGSize(width: 2, height: -3))

        #expect(sut.board[0][1] == 4)
        #expect(sut.board[0][3] == 2)
        #expect(numberOf(0, on: sut.board) == 17)
        #expect(numberOf(2, on: sut.board) == 2)
    }
    
    // MARK: - Swipe Down
    @Test("Swiping down from an initial board moves the 2 twos to the bottom row")
    func testSwipeDownFromInitialBoard() async throws {
        let sut = GameModel(initialBoard: [
            [0, 0, 0, 0, 0],
            [0, 0, 0, 2, 0],
            [0, 2, 0, 0, 0],
            [0, 0, 0, 0, 0]
        ])

        sut.userDidSwipe(translation: CGSize(width: 2, height: 3))

        #expect(sut.board[3][1] == 2)
        #expect(sut.board[3][3] == 2)
        #expect(numberOf(0, on: sut.board) == 17)
        #expect(numberOf(2, on: sut.board) == 3)
    }
    
    @Test("Given the user has swiped down, when a 2 bumps into another 2, they merge into a 4")
    func testSwipeDownMerge() async throws {
        let sut = GameModel(initialBoard: [
            [0, 2, 0, 0, 0],
            [0, 0, 0, 2, 0],
            [0, 2, 0, 0, 0],
            [0, 0, 0, 0, 0]
        ])

        sut.userDidSwipe(translation: CGSize(width: 2, height: 3))

        #expect(sut.board[3][1] == 4)
        #expect(sut.board[3][3] == 2)
        #expect(numberOf(0, on: sut.board) == 17)
        #expect(numberOf(2, on: sut.board) == 2)
    }
    
    // MARK: - Swipe Left
    @Test("Swiping left from an initial board moves the 2 twos to the leftmost column")
    func testSwipeLeftFromInitialBoard() async throws {
        let sut = GameModel(initialBoard: [
            [0, 0, 0, 0, 0],
            [0, 0, 0, 2, 0],
            [0, 2, 0, 0, 0],
            [0, 0, 0, 0, 0]
        ])

        sut.userDidSwipe(translation: CGSize(width: -3, height: 2))

        #expect(sut.board[1][0] == 2)
        #expect(sut.board[2][0] == 2)
        #expect(numberOf(0, on: sut.board) == 17)
        #expect(numberOf(2, on: sut.board) == 3)
    }
    
    @Test("Given the user has swiped left, when a 2 bumps into another 2, they merge into a 4")
    func testSwipeLeftMerge() async throws {
        let sut = GameModel(initialBoard: [
            [0, 0, 0, 0, 0],
            [0, 0, 0, 2, 0],
            [0, 2, 0, 2, 0],
            [0, 0, 0, 0, 0]
        ])

        sut.userDidSwipe(translation: CGSize(width: -3, height: 2))

        #expect(sut.board[1][0] == 2)
        #expect(sut.board[2][0] == 4)
        #expect(numberOf(0, on: sut.board) == 17)
        #expect(numberOf(2, on: sut.board) == 2)
    }
    
    // MARK: - Swipe Right
    @Test("Swiping right from an initial board moves the 2 twos to the rightmost column")
    func testSwipeRightFromInitialBoard() async throws {
        let sut = GameModel(initialBoard: [
            [0, 0, 0, 0, 0],
            [0, 0, 0, 2, 0],
            [0, 2, 0, 0, 0],
            [0, 0, 0, 0, 0]
        ])

        sut.userDidSwipe(translation: CGSize(width: 3, height: 2))

        #expect(sut.board[1][4] == 2)
        #expect(sut.board[2][4] == 2)
        #expect(numberOf(0, on: sut.board) == 17)
        #expect(numberOf(2, on: sut.board) == 3)
    }
    
    @Test("Given the user has swiped right, when a 2 bumps into another 2, they merge into a 4")
    func testSwipeRightMerge() async throws {
        let sut = GameModel(initialBoard: [
            [0, 0, 0, 0, 0],
            [0, 0, 0, 2, 0],
            [0, 2, 0, 2, 0],
            [0, 0, 0, 0, 0]
        ])

        sut.userDidSwipe(translation: CGSize(width: 3, height: 2))

        #expect(sut.board[1][4] == 2)
        #expect(sut.board[2][4] == 4)
        #expect(numberOf(0, on: sut.board) == 17)
        #expect(numberOf(2, on: sut.board) == 2)
    }
    
    // MARK: - End of Game
    @Test("Given no movement is possible, when the user swipes in any direction, the board does not change")
    func testGameOverNoMovementsPossibble() async throws {
        let sut = GameModel(initialBoard: [
            [2, 4, 2, 4, 2],
            [4, 2, 4, 2, 4],
            [2, 4, 2, 4, 2],
            [4, 2, 4, 2, 4]
        ])

        sut.userDidSwipe(translation: CGSize(width: 3, height: 2))
        sut.userDidSwipe(translation: CGSize(width: -3, height: 2))
        sut.userDidSwipe(translation: CGSize(width: 2, height: 3))
        sut.userDidSwipe(translation: CGSize(width: 2, height: -3))

        #expect(sut.board == [
            [2, 4, 2, 4, 2],
            [4, 2, 4, 2, 4],
            [2, 4, 2, 4, 2],
            [4, 2, 4, 2, 4]
        ])
    }
    
    @Test("Given no movement is possible, when the user swipes in any direction, the game is over")
    func testGameIsLost() async throws {
        let sut = GameModel(initialBoard: [
            [2, 4, 2, 4, 2],
            [4, 2, 4, 2, 4],
            [2, 4, 2, 4, 2],
            [4, 2, 4, 2, 4]
        ])

        sut.userDidSwipe(translation: CGSize(width: 3, height: 2))
        sut.userDidSwipe(translation: CGSize(width: -3, height: 2))
        sut.userDidSwipe(translation: CGSize(width: 2, height: 3))
        sut.userDidSwipe(translation: CGSize(width: 2, height: -3))

        #expect(sut.gameResult == .lost)
    }
    
    @Test("When a tile value is 2048, the user wins the game")
    func testGameIsWon() async throws {
        let sut = GameModel(initialBoard: [
            [2, 1024, 1024, 4, 2],
            [4, 2, 4, 2, 4],
            [2, 4, 2, 4, 2],
            [4, 2, 4, 2, 4]
        ])

        sut.userDidSwipe(translation: CGSize(width: -3, height: 2))

        #expect(sut.gameResult == .won)
    }
    
    @Test("tileWasMergedInLastMoveAt returns true for merged tile after swipe up")
    func testTileWasMergedAfterSwipeUp() async throws {
        let sut = GameModel(initialBoard: [
            [0, 0, 0, 0],
            [0, 2, 0, 2],
            [0, 0, 0, 0],
            [0, 2, 0, 0]
        ])

        sut.userDidSwipe(translation: CGSize(width: 0, height: -10)) // up

        #expect(sut.tileWasMergedInLastMoveAt(row: 0, col: 1)) // 2+2 merge at (0,1)
    }

    @Test("tileWasMergedInLastMoveAt returns false for non-merged tile after swipe up")
    func testTileWasNotMergedAfterSwipeUp() async throws {
        let sut = GameModel(initialBoard: [
            [0, 0, 0, 0],
            [0, 2, 0, 2],
            [0, 0, 0, 0],
            [0, 2, 0, 0]
        ])

        sut.userDidSwipe(translation: CGSize(width: 0, height: -10)) // up

        #expect(!sut.tileWasMergedInLastMoveAt(row: 0, col: 3)) // No merge at (0,3)
    }

    @Test("tileWasMergedInLastMoveAt returns true for merged tile after swipe left")
    func testTileWasMergedAfterSwipeLeft() async throws {
        let sut = GameModel(initialBoard: [
            [0, 0, 0, 0],
            [0, 0, 2, 2],
            [0, 0, 0, 0],
            [0, 0, 0, 0]
        ])

        sut.userDidSwipe(translation: CGSize(width: -10, height: 0)) // left

        #expect(sut.tileWasMergedInLastMoveAt(row: 1, col: 0)) // 2+2 merge at (1,0)
    }

    @Test("tileWasMergedInLastMoveAt returns false for all tiles before any move")
    func testTileWasMergedBeforeAnyMove() async throws {
        let sut = GameModel(initialBoard: [
            [0, 0, 0, 0],
            [0, 2, 0, 2],
            [0, 0, 0, 0],
            [0, 2, 0, 0]
        ])

        for row in 0..<4 {
            for col in 0..<4 {
                #expect(!sut.tileWasMergedInLastMoveAt(row: row, col: col))
            }
        }
    }
    
    private func numberOf(_ tileNumber: Int, on board: [[Int]]) -> Int {
        var tileNumberCount = 0
        
        board.flatMap(\.self).forEach { tileCaption in
            if tileCaption == tileNumber {
                tileNumberCount += 1
            }
        }
        
        return tileNumberCount
    }
}
