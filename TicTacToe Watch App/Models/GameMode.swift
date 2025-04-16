//
//  GameMode.swift
//  TicTacToe Watch App
//
//  Created by Michell Alexis Policarpio Moran
//

import Foundation

/// Enumeración que representa los diferentes modos de juego disponibles
enum GameMode: Identifiable {
    /// Modo para dos jugadores locales
    case twoPlayer
    
    /// Modo para un jugador contra la IA en dificultad fácil
    case singlePlayerEasy
    
    /// Modo para un jugador contra la IA en dificultad media
    case singlePlayerMedium
    
    /// Modo para un jugador contra la IA en dificultad difícil
    case singlePlayerHard
    
    /// ID único para conformar con Identifiable
    var id: String {
        switch self {
        case .twoPlayer:
            return "twoPlayer"
        case .singlePlayerEasy:
            return "singlePlayerEasy"
        case .singlePlayerMedium:
            return "singlePlayerMedium"
        case .singlePlayerHard:
            return "singlePlayerHard"
        }
    }
    
    /// Devuelve una descripción legible del modo de juego
    var description: String {
        switch self {
        case .twoPlayer:
            return "Dos Jugadores"
        case .singlePlayerEasy:
            return "IA: Fácil"
        case .singlePlayerMedium:
            return "IA: Media"
        case .singlePlayerHard:
            return "IA: Difícil"
        }
    }
    
    /// Indica si el modo de juego es contra la IA
    var isAIMode: Bool {
        switch self {
        case .twoPlayer:
            return false
        case .singlePlayerEasy, .singlePlayerMedium, .singlePlayerHard:
            return true
        }
    }
    
    /// Indica si el modo de juego es multijugador (dos jugadores)
    var multiPlayer: Bool {
        return !isAIMode
    }
} 