//
//  GameViewModel.swift
//  TicTacToe Watch App
//
//  Created by Michell Alexis Policarpio Moran
//

import Foundation
import Combine
import SwiftUI

/// Enumeración para los niveles de dificultad de la IA
enum GameDifficulty {
    case easy
    case medium
    case hard
}

/// ViewModel que gestiona la lógica del juego de Tres en Raya
class GameViewModel: ObservableObject {
    /// Modelo del juego
    private var game: Game
    
    /// Publicador para el estado del tablero
    @Published private(set) var boardState: [[CellState]] = []
    
    /// Jugador que comienza la partida
    @Published private(set) var startingPlayer: Player
    
    /// Jugador actual
    @Published private(set) var currentPlayer: Player = .x
    
    /// Indica si el juego ha terminado
    @Published private(set) var gameOver: Bool = false
    
    /// Jugador ganador (si existe)
    @Published private(set) var winner: Player?
    
    /// Línea ganadora (posiciones row, col)
    @Published private(set) var winningLine: [(Int, Int)]?
    
    /// Puntuación del jugador X
    @Published private(set) var scoreX: Int = 0
    
    /// Puntuación del jugador O
    @Published private(set) var scoreO: Int = 0
    
    /// Modo de juego actual
    let gameMode: GameMode
    
    /// Indica si la IA está pensando (para mostrar indicadores de actividad)
    @Published private(set) var isAIThinking: Bool = false
    
    /// Inicializa un nuevo ViewModel para el juego
    /// - Parameters:
    ///   - gameMode: Modo de juego seleccionado
    ///   - startingPlayer: Jugador que comienza la partida
    init(gameMode: GameMode, startingPlayer: Player = .x) {
        self.gameMode = gameMode
        self.startingPlayer = startingPlayer
        self.game = Game(startingPlayer: startingPlayer)
        self.currentPlayer = startingPlayer
        self.boardState = game.board
        
        // Si el primer turno es de la IA, hacer un movimiento automático
        if shouldMakeAIMove() {
            makeAIMove()
        }
    }
    
    /// Realiza un movimiento en la posición indicada
    /// - Parameters:
    ///   - row: Fila (0-2)
    ///   - col: Columna (0-2)
    func makeMove(row: Int, col: Int) {
        // No permitir movimientos si el juego ha terminado o si la IA está pensando
        guard !gameOver && !isAIThinking else { return }
        
        // Si es un juego contra la IA, solo permitir movimientos del jugador humano
        if gameMode.isAIMode && currentPlayer == getAIPlayer() {
            return
        }
        
        // Intentar realizar el movimiento
        var gameCopy = game
        let moveSuccessful = gameCopy.makeMove(row: row, col: col)
        
        if moveSuccessful {
            // Actualizar el modelo de juego
            game = gameCopy
            
            // Actualizar el estado del tablero
            boardState = game.board
            currentPlayer = game.currentPlayer
            
            // Comprobar si hay un ganador
            checkGameStatus()
            
            // Si el juego continúa y es el turno de la IA, hacer un movimiento automático
            if !gameOver && shouldMakeAIMove() {
                makeAIMove()
            }
        }
    }
    
    /// Comprueba si el juego ha terminado (victoria o empate)
    private func checkGameStatus() {
        let result = game.checkWinner()
        if let winner = result.winner {
            self.winner = winner
            self.winningLine = result.winningLine
            self.gameOver = true
            
            // Actualizar puntuación
            if winner == .x {
                scoreX += 1
            } else {
                scoreO += 1
            }
        } else if game.isBoardFull() {
            // Empate
            self.gameOver = true
            self.winner = nil
            self.winningLine = nil
        }
    }
    
    /// Inicia una nueva partida
    func startNewGame() {
        // Alternar el jugador inicial en cada nueva partida
        startingPlayer = startingPlayer.opposite
        
        // Reiniciar el juego
        var newGame = game
        newGame.restart(startingPlayer: startingPlayer)
        game = newGame
        
        boardState = game.board
        currentPlayer = startingPlayer
        gameOver = false
        winner = nil
        winningLine = nil
        
        // Si el primer turno es de la IA, hacer un movimiento automático
        if shouldMakeAIMove() {
            makeAIMove()
        }
    }
    
    /// Reinicia la puntuación a cero
    func resetScore() {
        scoreX = 0
        scoreO = 0
    }
    
    /// Verifica si es el turno de la IA
    /// - Returns: True si es el turno de la IA
    private func shouldMakeAIMove() -> Bool {
        guard gameMode.isAIMode else { return false }
        return currentPlayer == getAIPlayer()
    }
    
    /// Obtiene el jugador que representa a la IA
    /// - Returns: Player representando a la IA (X u O)
    private func getAIPlayer() -> Player {
        // En modo un jugador, la IA juega como O si el usuario empieza como X
        // O la IA juega como X si el usuario empieza como O
        if gameMode.isAIMode {
            // Siendo startingPlayer el jugador inicial aleatorio,
            // si startingPlayer es X, la IA es O
            // si startingPlayer es O, la IA es X
            return startingPlayer == .x ? .o : .x
        }
        return .empty // No debería llegar aquí
    }
    
    /// Realiza un movimiento automático de la IA
    private func makeAIMove() {
        // Marcar que la IA está pensando
        isAIThinking = true
        
        // Usar un retraso para simular que la IA está "pensando"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self, !self.gameOver else { return }
            
            var row: Int = 0
            var col: Int = 0
            
            // Seleccionar el algoritmo de la IA según el modo de juego
            switch self.gameMode {
            case .twoPlayer:
                return // No hay IA en modo dos jugadores
                
            case .singlePlayerEasy:
                // IA fácil: movimiento aleatorio
                (row, col) = self.randomMove()
                
            case .singlePlayerMedium:
                // IA media: combinación de aleatorio e inteligente
                if Bool.random() {
                    (row, col) = self.findBestMove()
                } else {
                    (row, col) = self.randomMove()
                }
                
            case .singlePlayerHard:
                // IA difícil: siempre busca el mejor movimiento
                (row, col) = self.findBestMove()
            }
            
            // Realizar el movimiento
            var gameCopy = self.game
            _ = gameCopy.makeMove(row: row, col: col)
            self.game = gameCopy
            
            self.boardState = self.game.board
            self.currentPlayer = self.game.currentPlayer
            
            // Comprobar si el juego ha terminado
            self.checkGameStatus()
            
            // La IA ha terminado de pensar
            self.isAIThinking = false
        }
    }
    
    /// Genera un movimiento aleatorio para la IA fácil
    /// - Returns: Posición (fila, columna) para el movimiento
    private func randomMove() -> (Int, Int) {
        let emptyPositions = game.getEmptyPositions()
        guard !emptyPositions.isEmpty else {
            return (0, 0) // No debería ocurrir si se comprueba correctamente el estado del juego
        }
        
        let randomIndex = Int.random(in: 0..<emptyPositions.count)
        return emptyPositions[randomIndex]
    }
    
    /// Encuentra el mejor movimiento para la IA difícil usando el algoritmo minimax
    /// - Returns: Posición (fila, columna) para el mejor movimiento
    private func findBestMove() -> (Int, Int) {
        let emptyPositions = game.getEmptyPositions()
        
        // Si solo hay una posición disponible, tomar esa
        if emptyPositions.count == 1 {
            return emptyPositions[0]
        }
        
        // Si es el primer movimiento, elegir una posición aleatoria
        if emptyPositions.count == 9 {
            return randomMove()
        }
        
        // Analizar cada posición disponible
        var bestScore = -1000
        var bestMove = (-1, -1)
        
        // Crear una copia del juego para simular movimientos
        let gameCopy = game
        let aiPlayer = gameCopy.currentPlayer
        
        for (row, col) in emptyPositions {
            // Probar este movimiento
            var moveGame = gameCopy
            _ = moveGame.makeMove(row: row, col: col)
            
            // Evaluar la posición resultante
            let score = minimax(game: moveGame, depth: 0, isMaximizing: false, player: aiPlayer)
            
            // Actualizar el mejor movimiento si es necesario
            if score > bestScore {
                bestScore = score
                bestMove = (row, col)
            }
        }
        
        return bestMove
    }
    
    /// Implementación del algoritmo minimax para la IA difícil
    /// - Parameters:
    ///   - game: Estado del juego
    ///   - depth: Profundidad actual en el árbol de decisiones
    ///   - isMaximizing: Indica si se está maximizando o minimizando
    ///   - player: Jugador para el que se está optimizando
    /// - Returns: Puntuación de la posición actual
    private func minimax(game: Game, depth: Int, isMaximizing: Bool, player: Player) -> Int {
        // Verificar si el juego ha terminado
        let result = game.checkWinner()
        if let winner = result.winner {
            return winner == player ? 10 - depth : depth - 10
        }
        
        if game.isBoardFull() {
            return 0 // Empate
        }
        
        let emptyPositions = game.getEmptyPositions()
        
        if isMaximizing {
            var bestScore = -1000
            
            for (row, col) in emptyPositions {
                var gameCopy = game
                _ = gameCopy.makeMove(row: row, col: col)
                let score = minimax(game: gameCopy, depth: depth + 1, isMaximizing: false, player: player)
                bestScore = max(score, bestScore)
            }
            
            return bestScore
        } else {
            var bestScore = 1000
            
            for (row, col) in emptyPositions {
                var gameCopy = game
                _ = gameCopy.makeMove(row: row, col: col)
                let score = minimax(game: gameCopy, depth: depth + 1, isMaximizing: true, player: player)
                bestScore = min(score, bestScore)
            }
            
            return bestScore
        }
    }
} 