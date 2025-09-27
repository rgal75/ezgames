//
//  GameModel.swift
//  Game2048
//
//  Created by Richard Gal on 2025. 03. 14..
//
import Foundation

typealias GameBoard = [[Int]]
typealias BoardSize = (width: Int, height: Int)

enum GameResult {
    case won
    case lost
    case ongoing
}

@Observable
final class GameModel {
    let boardSize: BoardSize
    var board: GameBoard
    var gameResult: GameResult = .ongoing
    
    // Stores the positions of tiles that merged in the last move
    private var mergedTiles: [(Int, Int)] = []
    
    enum Constants {
        static let winnerValue: Int = 2048
        static let initialBoardSize: BoardSize = (width: 4, height: 4)
    }
    private var lastMove: (up: Bool, down: Bool, left: Bool, right: Bool) = (true, true, true, true)
    
    init(boardSize: BoardSize = Constants.initialBoardSize) {
        self.boardSize = boardSize
        self.board = makeBoard(size: boardSize)
    }
    
    init(initialBoard: GameBoard) {
        self.boardSize = (width: initialBoard[0].count, height: initialBoard.count)
        self.board = initialBoard
    }
    
    func userDidSwipe(translation: CGSize) {
        if abs(translation.width) > abs(translation.height) {
            if translation.width > 0 {
                slideRight()
            } else {
                slideLeft()
            }
        } else {
            if translation.height > 0 {
                slideDown()
            } else {
                slideUp()
            }
        }
        if numberOf(Constants.winnerValue, on: board) > 0 {
            gameResult = .won
        }
        if !lastMove.up && !lastMove.down && !lastMove.left && !lastMove.right {
            gameResult = .lost
        }
    }
    
    private func slideUp() {
        mergedTiles.removeAll()
        var boardHasChanged = false
        for rowIdx in 0..<boardSize.height {
            let row = board[rowIdx]
            for colIdx in 0..<boardSize.width {
                let value = row[colIdx]
                guard value != 0 else { continue }
                var currentRowIdx = rowIdx
                while currentRowIdx > 0, board[currentRowIdx - 1][colIdx] == 0 {
                    board[currentRowIdx][colIdx] = 0
                    board[currentRowIdx - 1][colIdx] = value
                    boardHasChanged = true
                    currentRowIdx -= 1
                }
                if currentRowIdx > 0 && board[currentRowIdx - 1][colIdx] == value {
                    board[currentRowIdx - 1][colIdx] += value
                    boardHasChanged = true
                    board[currentRowIdx][colIdx] = 0
                    mergedTiles.append((currentRowIdx - 1, colIdx))
                }
            }
        }
        lastMove.up = boardHasChanged
        addRandomTile()
    }
    
    private func slideDown() {
        mergedTiles.removeAll()
        var boardHasChanged = false
        for rowIdx in (0..<boardSize.height).reversed() {
            let row = board[rowIdx]
            for colIdx in 0..<boardSize.width {
                let value = row[colIdx]
                guard value != 0 else { continue }
                var currentRowIdx = rowIdx
                while currentRowIdx < boardSize.height - 1, board[currentRowIdx + 1][colIdx] == 0 {
                    board[currentRowIdx][colIdx] = 0
                    board[currentRowIdx + 1][colIdx] = value
                    boardHasChanged = true
                    currentRowIdx += 1
                }
                if currentRowIdx < boardSize.height - 1 && board[currentRowIdx + 1][colIdx] == value {
                    board[currentRowIdx + 1][colIdx] += value
                    boardHasChanged = true
                    board[currentRowIdx][colIdx] = 0
                    mergedTiles.append((currentRowIdx + 1, colIdx))
                }
            }
        }
        lastMove.down = boardHasChanged
        addRandomTile()
    }
    
    private func slideLeft() {
        mergedTiles.removeAll()
        var boardHasChanged = false
        for rowIdx in 0..<boardSize.height {
            let row = board[rowIdx]
            for colIdx in 0..<boardSize.width {
                let value = row[colIdx]
                guard value != 0 else { continue }
                var currentColIdx = colIdx
                while currentColIdx > 0, board[rowIdx][currentColIdx - 1] == 0 {
                    board[rowIdx][currentColIdx] = 0
                    board[rowIdx][currentColIdx - 1] = value
                    boardHasChanged = true
                    currentColIdx -= 1
                }
                if currentColIdx > 0 && board[rowIdx][currentColIdx - 1] == value {
                    board[rowIdx][currentColIdx - 1] += value
                    boardHasChanged = true
                    board[rowIdx][currentColIdx] = 0
                    mergedTiles.append((rowIdx, currentColIdx - 1))
                }
            }
        }
        lastMove.left = boardHasChanged
        addRandomTile()
    }
    
    private func slideRight() {
        mergedTiles.removeAll()
        var boardHasChanged = false
        for rowIdx in 0..<boardSize.height {
            let row = board[rowIdx]
            for colIdx in (0..<boardSize.width).reversed() {
                let value = row[colIdx]
                guard value != 0 else { continue }
                var currentColIdx = colIdx
                while currentColIdx < boardSize.width - 1, board[rowIdx][currentColIdx + 1] == 0 {
                    board[rowIdx][currentColIdx] = 0
                    board[rowIdx][currentColIdx + 1] = value
                    boardHasChanged = true
                    currentColIdx += 1
                }
                if currentColIdx < boardSize.width - 1 && board[rowIdx][currentColIdx + 1] == value {
                    board[rowIdx][currentColIdx + 1] += value
                    boardHasChanged = true
                    board[rowIdx][currentColIdx] = 0
                    mergedTiles.append((rowIdx, currentColIdx + 1))
                }
            }
        }
        lastMove.right = boardHasChanged
        addRandomTile()
    }
    
    private func addRandomTile() {
        let emptyTiles = self.emptyTiles(on: board)
        guard !emptyTiles.isEmpty else { return }
        let randomIndex = Int.random(in: 0..<emptyTiles.count)
        let (rowIdx, colIdx) = emptyTiles[randomIndex]
        board[rowIdx][colIdx] = 2
    }
    
    private func emptyTiles(on board: [[Int]]) -> [(Int, Int)] {
        var emptyTiles = [(Int, Int)]()
        
        for rowIdx in 0..<boardSize.height {
            for colIdx in 0..<boardSize.width {
                if board[rowIdx][colIdx] == 0 {
                    emptyTiles.append((rowIdx, colIdx))
                }
            }
        }
        
        return emptyTiles
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
    
    func tileWasMergedInLastMoveAt(row: Int, col: Int) -> Bool {
        mergedTiles.contains { (pos: (Int, Int)) -> Bool in pos.0 == row && pos.1 == col }
    }
}

private func makeBoard(size: BoardSize) -> GameBoard {
    var board = Array(repeating: Array(repeating: 0, count: size.width), count: size.height)
    let random1 = Int.random(in: 0..<size.width * size.height)
    var random2: Int
    repeat {
        random2 = Int.random(in: 0..<size.width * size.height)
    } while (random1 == random2)
    board[random1 / size.width][random1 % size.width] = 2
    board[random2 / size.width][random2 % size.width] = 2
    return board
}
