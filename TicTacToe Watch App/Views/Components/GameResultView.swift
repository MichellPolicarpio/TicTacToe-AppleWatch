//
//  GameResultView.swift
//  TicTacToe Watch App
//
//  Created by Michell Alexis Policarpio Moran
//

import SwiftUI

/// Componente para mostrar los resultados del juego y botones de acción
struct GameResultView: View {
    /// Jugador ganador (nil si es empate)
    let winner: Player?
    
    /// Indica si hay empate
    let isTie: Bool
    
    /// Modo de juego actual
    let gameMode: GameMode
    
    /// Acción para jugar de nuevo
    let onPlayAgain: () -> Void
    
    /// Acción para volver al menú
    let onReturnToMenu: () -> Void
    
    var body: some View {
        VStack(spacing: 18) {
            // Mensaje según el resultado (ganador o empate)
            if isTie {
                Text("¡Empate!")
                    .font(.system(size: 20, weight: .bold))
            } else if let winner = winner {
                Text(resultMessage(for: winner))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(winner.color)
            }
            
            // Botones para jugar de nuevo o volver al menú
            VStack(spacing: 14) {
                Button(action: onPlayAgain) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Jugar de nuevo")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.green)
                    .cornerRadius(10)
                }
                
                Button(action: onReturnToMenu) {
                    HStack {
                        Image(systemName: "house.fill")
                        Text("Menú principal")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 10)
        }
        .padding(.vertical, 15)
        .background(Color.black.opacity(0.1))
        .cornerRadius(15)
        .padding(.horizontal, 6)
        .padding(.top, 8)
        .id("bottom")
    }
    
    /// Genera un mensaje descriptivo según el jugador ganador y el modo de juego
    /// - Parameter winner: Jugador ganador
    /// - Returns: Mensaje de resultado
    private func resultMessage(for winner: Player) -> String {
        if gameMode.isAIMode {
            return winner == .x ? "¡Ganaste!" : "¡Ganó la IA!"
        } else {
            return "¡Ganó \(winner.name)!"
        }
    }
}

/// Vista previa para el diseñador de SwiftUI
struct GameResultView_Previews: PreviewProvider {
    static var previews: some View {
        GameResultView(
            winner: Player.x,
            isTie: false,
            gameMode: .twoPlayer,
            onPlayAgain: {},
            onReturnToMenu: {}
        )
        .previewLayout(.sizeThatFits)
        .background(Color.black)
    }
} 