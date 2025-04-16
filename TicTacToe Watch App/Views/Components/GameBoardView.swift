//
//  GameBoardView.swift
//  TicTacToe Watch App
//
//  Created by Michell Alexis Policarpio Moran
//

import SwiftUI

/// Componente reutilizable para el tablero de juego
struct GameBoardView: View {
    /// ViewModel que gestiona el estado del juego
    @ObservedObject var viewModel: GameViewModel
    
    /// Acción a ejecutar cuando se pulsa una celda
    var onCellTap: (Int, Int) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Indicador de turno o resultado
            HStack {
                if !viewModel.gameOver {
                    Text("Turno: \(viewModel.currentPlayer.name)")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(viewModel.currentPlayer.color)
                } else if viewModel.winner == nil {
                    Text("Resultado: Empate")
                        .font(.system(size: 18, weight: .semibold))
                } else if let winner = viewModel.winner {
                    Text("Ganador: \(winner.name)")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(winner.color)
                }
                
                Spacer()
            }
            .padding(.vertical, 1)
            .padding(.leading, 12)
            
            // Pequeño espacio entre el turno y el tablero
            Spacer().frame(height: 4)
            
            // Tablero de juego
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 3), spacing: 4) {
                ForEach(0..<3) { row in
                    ForEach(0..<3) { col in
                        CellView(
                            cellState: viewModel.boardState[row][col],
                            onTap: {
                                onCellTap(row, col)
                            }
                        )
                        .disabled(viewModel.isAIThinking || viewModel.gameOver)
                    }
                }
            }
            .padding(.horizontal, 4)
            
            // Indicador de que la IA está pensando
            if viewModel.isAIThinking {
                Text("IA pensando...")
                    .font(.system(size: 14))
                    .foregroundColor(.orange)
                    .padding(.top, 4)
            }
        }
        .id("tablero")
    }
}

/// Vista para una celda individual del tablero
struct CellView: View {
    /// Estado de la celda
    let cellState: CellState
    
    /// Acción a ejecutar cuando se pulsa la celda
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Fondo de la celda
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.15))
                    .aspectRatio(1, contentMode: .fit)
                
                // Símbolo del jugador
                if let player = cellState.player {
                    Text(player.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(player.color)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// Vista previa para el diseñador de SwiftUI
struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView(
            viewModel: GameViewModel(gameMode: .twoPlayer),
            onCellTap: { _, _ in }
        )
        .previewLayout(.sizeThatFits)
        .background(Color.black)
    }
} 