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
            return .blue
        case .o:
            return .red
        case .empty:
            return .clear
        }
    }
} 