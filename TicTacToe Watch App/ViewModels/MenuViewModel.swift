//
//  MenuViewModel.swift
//  TicTacToe Watch App
//
//  Created by Michell Alexis Policarpio Moran
//

import Foundation
import SwiftUI

/// ViewModel para la pantalla del menú principal
class MenuViewModel: ObservableObject {
    /// Todos los modos de juego disponibles
    var availableModes: [GameMode] = [.twoPlayer, .singlePlayerEasy, .singlePlayerMedium, .singlePlayerHard]
    
    /// Modo de juego seleccionado
    @Published var selectedMode: GameMode = .twoPlayer
    
    /// Jugador que inicia la partida
    @Published var startingPlayer: Player = .x
    
    /// Controla la visualización de la vista "¿Cómo jugar?"
    @Published var showHowToPlay: Bool = false
    
    /// Controla la visualización de la vista del creador
    @Published var showCreator: Bool = false
    
    /// Recupera el icono asociado al modo de juego
    func icon(for mode: GameMode) -> String {
        switch mode {
        case .twoPlayer:
            return "person.2.fill"
        case .singlePlayerEasy:
            return "face.smiling"
        case .singlePlayerMedium:
            return "face.dashed"
        case .singlePlayerHard:
            return "bolt.shield"
        }
    }
    
    /// Recupera el color asociado al modo de juego
    func color(for mode: GameMode) -> Color {
        switch mode {
        case .twoPlayer:
            return .blue
        case .singlePlayerEasy:
            return .green
        case .singlePlayerMedium:
            return .orange
        case .singlePlayerHard:
            return .red
        }
    }
    
    /// Cambia el jugador inicial
    func toggleStartingPlayer() {
        if startingPlayer == .x {
            startingPlayer = .o
        } else {
            startingPlayer = .x
        }
    }
    
    /// Crea un nuevo ViewModel de juego con la configuración actual
    /// - Returns: GameViewModel configurado con las opciones seleccionadas
    func createGameViewModel() -> GameViewModel {
        // Seleccionar aleatoriamente quién empieza
        let randomStartingPlayer = Bool.random() ? Player.x : Player.o
        
        return GameViewModel(gameMode: selectedMode, startingPlayer: randomStartingPlayer)
    }
} 