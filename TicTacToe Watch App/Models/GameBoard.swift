//
//  GameBoard.swift
//  TicTacToe Watch App
//
//  Created by Michell Alexis Policarpio Moran
//

import Foundation

/// Representa el estado del tablero de juego
struct GameBoard {
    /// Celdas del tablero (cadena vacía si está libre, "X" u "O" si está ocupada)
    private(set) var cells: [String]
    
    /// Índices de la combinación ganadora, si existe
    private(set) var winningIndices: [Int] = []
    
    /// Combinaciones ganadoras posibles
    static let winningCombinations = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8],  // Horizontal
        [0, 3, 6], [1, 4, 7], [2, 5, 8],  // Vertical
        [0, 4, 8], [2, 4, 6]              // Diagonal
    ]
    
    /// Crea un nuevo tablero de juego, por defecto vacío
    init(cells: [String] = Array(repeating: "", count: 9)) {
        self.cells = cells
    }
    
    /// Coloca un símbolo en la posición especificada
    /// - Parameters:
    ///   - symbol: "X" u "O"
    ///   - index: Índice de la celda (0-8)
    /// - Returns: Tablero actualizado
    func placing(_ symbol: String, at index: Int) -> GameBoard {
        guard index >= 0 && index < cells.count && cells[index].isEmpty else {
            return self // No se puede colocar en una celda ocupada o inválida
        }
        
        var newCells = cells
        newCells[index] = symbol
        return GameBoard(cells: newCells)
    }
    
    /// Verifica si hay un ganador en el tablero actual
    /// - Returns: Tupla con el símbolo ganador (nil si no hay) y los índices de la combinación ganadora
    func checkWinner() -> (winner: String?, winningIndices: [Int]) {
        for combo in Self.winningCombinations {
            if cells[combo[0]] != "" &&
               cells[combo[0]] == cells[combo[1]] &&
               cells[combo[1]] == cells[combo[2]] {
                return (cells[combo[0]], combo)
            }
        }
        
        // Verificar empate
        if !cells.contains("") {
            return ("Empate", []) // Empate
        }
        
        return (nil, []) // Juego en curso
    }
    
    /// Actualiza los índices de la combinación ganadora
    /// - Parameter indices: Índices de la combinación ganadora
    /// - Returns: Tablero actualizado con los índices ganadores
    func withWinningIndices(_ indices: [Int]) -> GameBoard {
        var board = self
        board.winningIndices = indices
        return board
    }
    
    /// Reinicia el tablero a su estado inicial
    /// - Returns: Tablero vacío
    static func empty() -> GameBoard {
        return GameBoard()
    }
} 