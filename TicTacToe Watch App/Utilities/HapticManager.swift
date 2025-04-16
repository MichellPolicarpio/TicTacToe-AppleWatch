//
//  HapticManager.swift
//  TicTacToe Watch App
//
//  Created by Michell Alexis Policarpio Moran
//

import Foundation
import WatchKit

/// Gestor de retroalimentación háptica
class HapticManager {
    /// Tipos de retroalimentación háptica disponibles
    enum FeedbackType {
        case move        // Al realizar un movimiento
        case win         // Al ganar
        case lose        // Al perder
        case tie         // Al empatar
        case selection   // Al seleccionar un elemento UI
    }
    
    /// Proporciona retroalimentación háptica según el tipo especificado
    /// - Parameter type: Tipo de retroalimentación
    func playHaptic(for type: FeedbackType) {
        switch type {
        case .move:
            WKInterfaceDevice.current().play(.click)
        case .win:
            WKInterfaceDevice.current().play(.success)
        case .lose:
            WKInterfaceDevice.current().play(.failure)
        case .tie:
            WKInterfaceDevice.current().play(.notification)
        case .selection:
            WKInterfaceDevice.current().play(.directionUp)
        }
    }
    
    /// Proporciona retroalimentación háptica para una secuencia de tipos con retrasos
    /// - Parameter sequence: Array de tuplas con tipo de retroalimentación y tiempo de espera (en segundos)
    func playSequence(_ sequence: [(type: FeedbackType, delay: TimeInterval)]) {
        // Manejar secuencias de hápticos con retrasos entre ellos
        var cumulativeDelay: TimeInterval = 0
        
        for (type, delay) in sequence {
            cumulativeDelay += delay
            DispatchQueue.main.asyncAfter(deadline: .now() + cumulativeDelay) {
                self.playHaptic(for: type)
            }
        }
    }
} 