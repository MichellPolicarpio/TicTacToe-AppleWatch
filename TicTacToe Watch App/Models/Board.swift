//
//  Board.swift
//  TicTacToe Watch App
//
//  Created by Michell Alexis Policarpio Moran
//

import Foundation

/// Modelo que representa el tablero de juego
struct Board {
    /// Tamaño del tablero (3x3)
    let size = 3
    
    /// Matriz que almacena las celdas del tablero
    private var cells: [[Player?]]
    
    /// Inicializa un tablero vacío
    init() {
        cells = Array(repeating: Array(repeating: nil, count: size), count: size)
    }
    
    /// Obtiene el valor de una celda
    /// - Parameters:
    ///   - row: Fila
    ///   - col: Columna
    /// - Returns: Jugador en la celda, o nil si está vacía
    func cell(at row: Int, _ col: Int) -> Player? {
        return cells[row][col]
    }
    
    /// Marca una celda con el símbolo del jugador
    /// - Parameters:
    ///   - row: Fila
    ///   - col: Columna
    ///   - player: Jugador que marca la celda
    /// - Returns: Nuevo tablero con la celda marcada
    func marking(at row: Int, _ col: Int, with player: Player) -> Board {
        var newBoard = self
        newBoard.cells[row][col] = player
        return newBoard
    }
    
    /// Verifica si hay una celda vacía en la posición indicada
    /// - Parameters:
    ///   - row: Fila
    ///   - col: Columna
    /// - Returns: true si la celda está vacía, false en caso contrario
    func isEmptyCell(at row: Int, _ col: Int) -> Bool {
        return cells[row][col] == nil
    }
    
    /// Obtiene todas las posiciones vacías del tablero
    /// - Returns: Array de tuplas (fila, columna) que representan las celdas vacías
    func emptyPositions() -> [(row: Int, col: Int)] {
        var positions = [(row: Int, col: Int)]()
        
        for row in 0..<size {
            for col in 0..<size {
                if isEmptyCell(at: row, col) {
                    positions.append((row: row, col: col))
                }
            }
        }
        
        return positions
    }
    
    /// Verifica si el tablero está lleno
    /// - Returns: true si no hay celdas vacías, false en caso contrario
    var isFull: Bool {
        return emptyPositions().isEmpty
    }
    
    /// Verifica si hay un ganador en el tablero
    /// - Returns: El jugador ganador, o nil si no hay ganador
    func winner() -> Player? {
        // Comprobar filas
        for row in 0..<size {
            if let player = cells[row][0], 
               player == cells[row][1] && player == cells[row][2] {
                return player
            }
        }
        
        // Comprobar columnas
        for col in 0..<size {
            if let player = cells[0][col], 
               player == cells[1][col] && player == cells[2][col] {
                return player
            }
        }
        
        // Comprobar diagonal principal
        if let player = cells[0][0], 
           player == cells[1][1] && player == cells[2][2] {
            return player
        }
        
        // Comprobar diagonal secundaria
        if let player = cells[0][2], 
           player == cells[1][1] && player == cells[2][0] {
            return player
        }
        
        return nil
    }
    
    /// Verifica si el juego ha terminado (hay ganador o empate)
    /// - Returns: true si el juego ha terminado, false en caso contrario
    var isGameOver: Bool {
        return winner() != nil || isFull
    }
} 