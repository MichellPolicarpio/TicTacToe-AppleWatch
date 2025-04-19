//
//  Player.swift
//  TicTacToe Watch App
//
//  Created by Michell Alexis Policarpio Moran
//

import Foundation
import SwiftUI

/// Enumeration that represents players in the game
enum Player {
    /// X player
    case x
    
    /// O player
    case o
    
    /// Empty cell, no player
    case empty
    
    /// Returns the opposite player (X -> O, O -> X)
    /// Empty remains empty
    var opposite: Player {
        switch self {
        case .x:
            return .o
        case .o:
            return .x
        case .empty:
            return .empty
        }
    }
    
    /// Returns true if this player is X or O (not empty)
    var isPlayer: Bool {
        return self != .empty
    }
    
    /// Returns the symbol representing this player
    var symbol: String {
        switch self {
        case .x:
            return "X"
        case .o:
            return "O"
        case .empty:
            return ""
        }
    }
    
    /// Devuelve el nombre del jugador
    var name: String {
        switch self {
        case .x:
            return "X"
        case .o:
            return "O"
        case .empty:
            return ""
        }
    }
    
    /// Devuelve el color asociado al jugador
    var color: Color {
        switch self {
        case .x:
            return Color(red: 0.1, green: 0.6, blue: 1.0) // Azul más intenso y vibrante
        case .o:
            return Color(red: 1.0, green: 0.1, blue: 0.3) // Mantenemos el rojo brillante
        case .empty:
            return .clear
        }
    }
} 