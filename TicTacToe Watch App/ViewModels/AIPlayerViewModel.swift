//
//  AIPlayerViewModel.swift
//  TicTacToe Watch App
//
//  Created by Michell Alexis Policarpio Moran
//

import Foundation
import Combine
import SwiftUI

/// ViewModel para gestionar la lógica de la IA en el juego
class AIPlayerViewModel: ObservableObject {
    /// Modelo del juego
    private var game: Game
    
    /// Nivel de dificultad de la IA
    let difficulty: GameMode
    
    /// Jugador que representa la IA
    let aiPlayer: Player
    
    /// Inicializa la IA con un nivel de dificultad
    /// - Parameters:
    ///   - difficulty: Nivel de dificultad de la IA
    ///   - game: Modelo del juego actual
    ///   - aiPlayer: Jugador que representa la IA
    init(difficulty: GameMode, game: Game, aiPlayer: Player) {
        self.difficulty = difficulty
        self.game = game
        self.aiPlayer = aiPlayer
        
        // La IA solo puede ser usada en modos de un jugador
        if difficulty == .twoPlayer {
            fatalError("AIPlayerViewModel no puede ser inicializado en modo multijugador")
        }
    }
    
    /// Realiza un movimiento de la IA según el nivel de dificultad
    /// - Returns: La posición (fila, columna) donde la IA decide jugar
    func makeMove() -> (row: Int, col: Int)? {
        // Obtener las posiciones vacías
        let emptyPositions = game.getEmptyPositions()
        if emptyPositions.isEmpty {
            return nil
        }
        
        // Según la dificultad, utilizar una estrategia diferente
        switch difficulty {
        case .singlePlayerEasy:
            return randomMove(from: emptyPositions)
        case .singlePlayerMedium:
            return Bool.random() ? smartMove() : randomMove(from: emptyPositions)
        case .singlePlayerHard:
            return smartMove()
        default:
            return randomMove(from: emptyPositions)
        }
    }
    
    /// Elige un movimiento aleatorio entre las posiciones disponibles
    /// - Parameter positions: Posiciones disponibles
    /// - Returns: Una posición aleatoria
    private func randomMove(from positions: [(Int, Int)]) -> (row: Int, col: Int) {
        let randomIndex = Int.random(in: 0..<positions.count)
        return positions[randomIndex]
    }
    
    /// Realiza un movimiento inteligente basado en el algoritmo minimax
    /// - Returns: La mejor posición posible
    private func smartMove() -> (row: Int, col: Int) {
        // Si es la primera jugada, hacer algo aleatorio para variedad
        let emptyPositions = game.getEmptyPositions()
        if emptyPositions.count == 9 {
            return randomMove(from: emptyPositions)
        }
        
        // Usar minimax para encontrar la mejor jugada
        var bestScore = Int.min
        var bestMove = (row: 0, col: 0)
        
        // Evaluar cada posición posible
        for (row, col) in emptyPositions {
            var gameCopy = game
            _ = gameCopy.makeMove(row: row, col: col)
            
            let score = minimax(game: gameCopy, depth: 0, isMaximizing: false)
            
            if score > bestScore {
                bestScore = score
                bestMove = (row, col)
            }
        }
        
        return bestMove
    }
    
    /// Implementación del algoritmo minimax para evaluar posiciones
    /// - Parameters:
    ///   - game: Estado del juego a evaluar
    ///   - depth: Profundidad actual en la recursión
    ///   - isMaximizing: Si se está maximizando o minimizando
    /// - Returns: Puntuación de la posición
    private func minimax(game: Game, depth: Int, isMaximizing: Bool) -> Int {
        // Verificar si hay un ganador
        if let winner = game.checkWinner() {
            if winner == aiPlayer {
                return 10 - depth // La IA gana, es bueno
            } else {
                return depth - 10 // El oponente gana, es malo
            }
        }
        
        // Si es empate
        if game.isBoardFull() {
            return 0
        }
        
        // Recursivamente evaluar todas las jugadas posibles
        if isMaximizing {
            var bestScore = Int.min
            
            for (row, col) in game.getEmptyPositions() {
                var gameCopy = game
                _ = gameCopy.makeMove(row: row, col: col)
                
                let score = minimax(game: gameCopy, depth: depth + 1, isMaximizing: false)
                bestScore = max(bestScore, score)
            }
            
            return bestScore
        } else {
            var bestScore = Int.max
            
            for (row, col) in game.getEmptyPositions() {
                var gameCopy = game
                _ = gameCopy.makeMove(row: row, col: col)
                
                let score = minimax(game: gameCopy, depth: depth + 1, isMaximizing: true)
                bestScore = min(bestScore, score)
            }
            
            return bestScore
        }
    }
} 