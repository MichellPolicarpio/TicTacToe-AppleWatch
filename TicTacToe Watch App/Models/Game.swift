//
//  Game.swift
//  TicTacToe Watch App
//
//  Created by Michell Alexis Policarpio Moran
//

import Foundation

/// Representa el estado de una casilla en el tablero
enum CellState: Equatable {
    case empty
    case occupied(Player)
    
    /// Verifica si la casilla está vacía
    var isEmpty: Bool {
        if case .empty = self {
            return true
        }
        return false
    }
    
    /// Devuelve el jugador que ocupa la casilla, si existe
    var player: Player? {
        if case .occupied(let player) = self {
            return player
        }
        return nil
    }
    
    /// Implementación de Equatable
    static func == (lhs: CellState, rhs: CellState) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case (.occupied(let player1), .occupied(let player2)):
            return player1 == player2
        default:
            return false
        }
    }
}

/// Estado del juego
enum GameState {
    case playing
    case won(Player)
    case draw
}

/// Modelo que representa el estado actual del juego
struct Game {
    /// Tamaño del tablero (3x3)
    static let boardSize = 3
    
    /// Estado actual del tablero
    private(set) var board: [[CellState]]
    
    /// Jugador actual
    private(set) var currentPlayer: Player
    
    /// Estado actual del juego
    var state: GameState {
        if let winner = checkWinner().winner {
            return .won(winner)
        } else if isBoardFull() {
            return .draw
        } else {
            return .playing
        }
    }
    
    /// Inicializa un nuevo juego
    /// - Parameter startingPlayer: Jugador que comienza la partida
    init(startingPlayer: Player = .x) {
        // Crear tablero vacío
        self.board = Array(repeating: Array(repeating: .empty, count: Game.boardSize), count: Game.boardSize)
        self.currentPlayer = startingPlayer
    }
    
    /// Realiza un movimiento en la posición especificada
    /// - Parameters:
    ///   - row: Fila (0-2)
    ///   - col: Columna (0-2)
    /// - Returns: True si el movimiento fue válido, false en caso contrario
    mutating func makeMove(row: Int, col: Int) -> Bool {
        guard isValidPosition(row: row, col: col) && board[row][col].isEmpty else {
            return false
        }
        
        board[row][col] = .occupied(currentPlayer)
        currentPlayer = currentPlayer.opposite
        return true
    }
    
    /// Verifica si la posición es válida
    /// - Parameters:
    ///   - row: Fila
    ///   - col: Columna
    /// - Returns: True si la posición está dentro del tablero
    private func isValidPosition(row: Int, col: Int) -> Bool {
        return row >= 0 && row < Game.boardSize && col >= 0 && col < Game.boardSize
    }
    
    /// Verifica si el juego ha terminado
    /// - Returns: El jugador ganador o nil si no hay ganador todavía
    func checkWinner() -> (winner: Player?, winningLine: [(Int, Int)]?) {
        // Comprobar filas
        for row in 0..<Game.boardSize {
            let positions = (0..<Game.boardSize).map { (row, $0) }
            if let winner = checkLine(positions: positions) {
                return (winner, positions)
            }
        }
        
        // Comprobar columnas
        for col in 0..<Game.boardSize {
            let positions = (0..<Game.boardSize).map { ($0, col) }
            if let winner = checkLine(positions: positions) {
                return (winner, positions)
            }
        }
        
        // Comprobar diagonal principal
        let diag1 = (0..<Game.boardSize).map { ($0, $0) }
        if let winner = checkLine(positions: diag1) {
            return (winner, diag1)
        }
        
        // Comprobar diagonal secundaria
        let diag2 = (0..<Game.boardSize).map { ($0, Game.boardSize - 1 - $0) }
        if let winner = checkLine(positions: diag2) {
            return (winner, diag2)
        }
        
        return (nil, nil)
    }
    
    /// Verifica si hay un ganador en una línea específica
    /// - Parameter positions: Array de posiciones (fila, columna) a comprobar
    /// - Returns: El jugador ganador o nil si no hay ganador
    private func checkLine(positions: [(Int, Int)]) -> Player? {
        var firstPlayer: Player?
        
        for (row, col) in positions {
            guard let player = board[row][col].player else {
                return nil // Hay una celda vacía, no hay ganador
            }
            
            if firstPlayer == nil {
                firstPlayer = player
            } else if player != firstPlayer {
                return nil // No todos los jugadores son iguales, no hay ganador
            }
        }
        
        return firstPlayer
    }
    
    /// Verifica si el tablero está lleno (empate)
    /// - Returns: True si todas las celdas están ocupadas
    func isBoardFull() -> Bool {
        for row in 0..<Game.boardSize {
            for col in 0..<Game.boardSize {
                if board[row][col].isEmpty {
                    return false
                }
            }
        }
        return true
    }
    
    /// Reinicia el juego con un jugador inicial especificado
    /// - Parameter startingPlayer: Jugador que comienza la nueva partida
    mutating func restart(startingPlayer: Player = .x) {
        board = Array(repeating: Array(repeating: .empty, count: Game.boardSize), count: Game.boardSize)
        currentPlayer = startingPlayer
    }
    
    /// Devuelve las posiciones vacías en el tablero
    /// - Returns: Array de posiciones (fila, columna) vacías
    func getEmptyPositions() -> [(Int, Int)] {
        var emptyPositions: [(Int, Int)] = []
        
        for row in 0..<Game.boardSize {
            for col in 0..<Game.boardSize {
                if board[row][col].isEmpty {
                    emptyPositions.append((row, col))
                }
            }
        }
        
        return emptyPositions
    }
} 